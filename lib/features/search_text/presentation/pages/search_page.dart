import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/animations/animations.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/core/widgets/bottom_sheet.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/data_generated/presentation/bloc/data_generated_bloc.dart';
import 'package:gemini/features/search_text/presentation/provider/search_type_provider.dart';
import 'package:gemini/features/search_text/presentation/widgets/data_add.dart';
import 'package:gemini/features/search_text/presentation/widgets/generated_data_title.dart';
import 'package:gemini/features/search_text/presentation/widgets/icon_button.dart';
import 'package:gemini/features/search_text/presentation/widgets/read_data_generated.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/bloc/search_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/history_shimmer.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/search_text/presentation/widgets/slidable_action.dart';
import 'package:gemini/features/sqlite_database/entities/text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';

class SearchTextPage extends StatefulWidget {
  const SearchTextPage({super.key});
  @override
  State<SearchTextPage> createState() => _SearchTextPage();
}

class _SearchTextPage extends State<SearchTextPage>
    with SingleTickerProviderStateMixin {
  final form = GlobalKey<FormState>();
  final searchBloc = sl<SearchBloc>();
  final dataGeneratedBloc = sl<DataGeneratedBloc>();
  final searchBloc2 = sl<SearchBloc>();
  final ScrollController _scrollController = ScrollController();
  final searchBloc3 = sl<SearchBloc>();
  final authBloc = sl<AuthenticationBloc>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? animation;
  late AnimationController animatedController;

  List<Uint8List> all = [], newAll = [];
  List<String> imageExtensions = [], snapInfo = [], streamData = [];
  int imageLength = 0;
  int? searchType;
  String info = "How can I help you today?",
      repeatQuestion = "",
      name = "",
      joinedSnapInfo = "",
      initText = "";
  bool isStream = true,
      isTextImage = true,
      isAdded = false,
      canDeleteData = false,
      isAvailable = false,
      isSpeechTextEnabled = false;
  String? question, refinedData, token, profile;
  final controller = TextEditingController();
  Uint8List? byte;
  TokenProvider? tokenProvider;
  late User user;
  int time = 1;
  String getTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time++;
      });
      if (!isSpeechTextEnabled) {
        time = 0;
        setState(() {});
        timer.cancel();
      }
    });
    return time.toString();
  }

  Future<List<TextEntity>?> remove() async {
    return await searchBloc.readData();
  }

  double opacity = 1;
  @override
  void initState() {
    super.initState();
    initText = controller.text;
    searchBloc2.add(ReadSQLDataEvent());
    animatedController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = DecorationTween().animate(animatedController);
    animation?.addListener(() {
      setState(() {
        // color = animation?.value;
      });
    });
    animation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animatedController.reset();
        animatedController.forward();
      } else if (status == AnimationStatus.dismissed) {
        animatedController.forward();
      }
    });
    animatedController.forward();
  }

  @override
  void dispose() {
    animatedController.dispose();
    // animation?.removeStatusListener((status) {});
    super.dispose();
  }

  List<TextEntity>? data = [];

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      ),
    );
  }

  void execute({
    required TextEntity textEntity,
    bool? isTextImage,
  }) async {
    searchBloc2.add(ReadAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    token = context.read<TokenProvider>().token;
    user = context.watch<UserProvider>().user!;
    final search = context.watch<SearchTypeProvider>();
    searchType = context.watch<SearchTypeProvider>().checkIndex;
    profile = context.watch<UserProvider>().profile;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.black,
          title: const Text("Jerrito Gemini AI"),
          leading: IconButton(
              onPressed: () async {
                // context.pushNamed("test");
                allSelectIds.clear();
                ids.clear();
                dataGeneratedBloc
                    .add(ListDataGeneratedEvent(params: {"token": token}));
                scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu)),
          centerTitle: true,
          actions: [
            BlocListener(
              bloc: searchBloc3,
              listener: (context, state) {
                if (state is OnSpeechResultLoaded) {
                  controller.text = state.result;
                  setState(() {});
                }
                if (state is IsSpeechTextEnabledError) {
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
                if (state is IsSpeechTextEnabledLoaded) {
                  searchBloc3.add(
                    ListenSpeechTextEvent(),
                  );
                  setState(() {
                    isSpeechTextEnabled = !isSpeechTextEnabled;
                  });
                  getTime();
                }
                if (state is StopSpeechTextLoaded) {
                  setState(() {
                    isSpeechTextEnabled = !isSpeechTextEnabled;
                  });
                  if (controller.text.isNotEmpty) {
                    Map<String, dynamic> params = {
                      "text": controller.text,
                    };
                    searchBloc.add(
                      GenerateContentEvent(params: params),
                    );
                  }
                }
              },
              child: GestureDetector(
                onTap: () => searchBloc3.add(isSpeechTextEnabled
                    ? StopSpeechTextEvent()
                    : IsSpeechTextEnabledEvent()),
                child: isSpeechTextEnabled
                    ? Container(
                        height: Sizes().height(context, 0.07),
                        width: Sizes().width(context, 0.14),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 18, 33, 207),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.mic, color: Colors.red),
                      )
                    : const Icon(Icons.mic),
              ),
            ),
            Space().width(context, 0.04)
          ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     context.goNamed("becomeATeacher");
      //   },
      //   child: AnimatedOpacity(
      //     duration: Durations.extralong2,
      //     opacity: opacity,
      //     onEnd: () async {
      //       while (true) {
      //         Future.delayed(Durations.extralong1, () {
      //           setState(() {
      //             opacity = 0;
      //           });
      //         }).whenComplete(() {
      //           Future.delayed(Durations.extralong1, () {
      //             setState(() {
      //               opacity = 1;
      //             });
      //           });
      //         });
      //       }
      //     },
      //     child: Container(
      //         width: double.infinity,
      //         height: Sizes().height(context, 0.03),
      //         decoration: const BoxDecoration(color: Colors.blueAccent),
      //         child: const Text("Hello", textAlign: TextAlign.center)),
      //   ),
      // ),
      bottomSheet: Form(
        key: form,
        child: Container(
          color: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.black,
          child: BottomSheetTextfield(
              byte: byte,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "";
                }

                return null;
              },
              onChanged: (value) {
                if (value!.isEmpty) {
                  isAvailable = false;
                  setState(() {});
                }
                if (value.isNotEmpty) {
                  isAvailable = true;
                  setState(() {});
                }
                initText = value;
              },
              controller: controller,
              onPressed: !isAvailable
                  ? null
                  : () {
                      if (form.currentState?.validate() == true &&
                          controller.text.isNotEmpty) {
                        Map<String, dynamic> params = {
                          "text": controller.text,
                        };
                        Map<String, dynamic> paramsWithImage = {
                          "text": controller.text,
                          "ext": imageExtensions,
                          "image": all,
                          "images": imageLength,
                        };
                        switch (!isStream) {
                          case true:
                            searchBloc.add(
                              SearchTextAndImageEvent(
                                params: paramsWithImage,
                              ),
                            );
                            break;
                          case false:
                            searchBloc.add(
                              GenerateContentEvent(
                                params: params,
                              ),
                            );
                            break;
                          default:
                            searchBloc.add(
                              GenerateContentEvent(
                                params: params,
                              ),
                            );
                            break;
                        }
                      }
                    },
              onTap: () {
                searchBloc2.add(AddMultipleImageEvent(
                  noParams: NoParams(),
                ));
              },
              isTextAndImage: isTextImage,
              isTextEmpty: isAvailable,
              isAdded: isAdded),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes().width(
            context,
            0.04,
          ),
          vertical: Sizes().height(
            context,
            0.02,
          ),
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener(
              bloc: searchBloc2,
              listener: (context, state) async {
                if (state is AddMultipleImageLoaded) {
                  all.clear();
                  imageExtensions.clear();
                  imageLength = 0;
                  question = "";
                  for (int i = 0; i < state.data.length; i++) {
                    all.addAll(state.data.keys.elementAt(i));
                    imageExtensions.addAll(state.data.values.elementAt(i));
                  }
                  imageLength = all.length;
                  byte = all[0];
                  isTextImage = false;
                  isAdded = true;
                  setState(() {});
                }
                if (state is AddMultipleImageLoading) {
                  isAdded = false;
                  isTextImage = false;
                  isStream = false;
                  setState(() {});
                }
                if (state is AddMultipleImageError) {
                  isTextImage = true;
                  isAdded = false;
                  isStream = true;
                  setState(() {});
                }
                if (state is ReadDataLoaded) {
                  final data = state.data;
                  searchBloc2.add(DeleteDataEvent(params: data));
                }
              },
            ),
            BlocListener(
              bloc: dataGeneratedBloc,
              listener: (context, state) {
                if (state is DataGeneratedError) {
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
                if (state is DataGeneratedLoaded) {
                  if (isStream) {
                    snapInfo.clear();
                  }
                }
                if (state is DataGeneratedLoading) {
                  if (isStream) {
                    searchBloc.add(ReadSQLDataEvent());
                  }
                }
              },
            ),
          ],
          child: BlocConsumer(
            bloc: searchBloc,
            listener: (context, state) async {
              if (state is ReadDataLoaded) {
                _scrollDown();
              }
              // if (state is GenerateStreamLoading) {
              //   question = controller.text;
              //   controller.text = "";
              //   setState(() {});
              // }
              if (state is SearchTextAndImageLoaded) {
                question = controller.text;
                controller.text = "";
                final newId = await searchBloc.readData();
                final data = state.data;
                refinedData = searchBloc.replace(data);
                Map<String, dynamic> params = {
                  "token": token,
                  "textId": newId!.isNotEmpty ? newId.last.textId + 1 : 1,
                  "title": (question!.isNotEmpty ? question! : repeatQuestion),
                  "data": refinedData,
                  // "dateTime": DateTime.now(),
                  "hasImage": true,
                  "dataImage": byte
                };
                isAdded = false;
                isTextImage = true;
                isStream = true;
                setState(() {});
                await searchBloc.addData(params);
                dataGeneratedBloc.add(DataEvent(params: params));
              }

              if (state is ReadAll) {
                // final textEntity = data!.last;
                // final params = {
                //   "token": token,
                //   "data": textEntity.data?.replaceAll("\n", ""),
                //   "title": textEntity.title,
                //   "dataImage": textEntity.dataImage,
                //   "hasImage": textEntity.hasImage
                // };
                _scrollDown();
                // searchBloc.add(DataEvent(params: params));
              }
              if (state is GenerateContentAllDone) {
                // final newId = await searchBloc.readData();
                final refinedData = searchBloc.replace(snapInfo.join(""));
                Map<String, dynamic> params = {
                  "token": token,
                  // "textId": newId!.isNotEmpty ? newId.last.textId + 1 : 1,
                  "title": (question!.isNotEmpty ? question! : repeatQuestion),
                  "data": refinedData,
                  "hasImage": false,
                  "dataImage": null
                };
                dataGeneratedBloc.add(DataEvent(params: params));
              }
              if (state is GenerateContentLoaded) {
                final data = state.data;
                snapInfo.add(data);
                _scrollDown();
              }
              if (state is GenerateStreamLoading) {
                question = controller.text;
                controller.text = "";
                isAvailable = false;
                isStream = !isStream;
                snapInfo.clear();
                search.reset();
                setState(() {});
              }
              if (state is SearchTextAndImageLoading) {
                question = controller.text;
                controller.text = "";
                setState(() {});
              }

              if (state is GenerateContentError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
              if (state is SearchTextAndImageError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is SearchTextAndImageLoading ||
                  state is SearchTextLoading ||
                  state is ReadDataLoading) {
                return Column(
                  children: [
                    Center(
                      child: Lottie.asset(
                        aiJson,
                      ),
                    ),
                  ],
                );
              }

              if (state is GenerateContentLoaded) {
                return Column(
                  children: [
                    Space().height(context, 0.01),
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          final dataRead = await searchBloc.readData();
                          if (dataRead?.isNotEmpty ?? false) {
                            if (dataRead!.length > searchType!) {
                              final index = dataRead.length - searchType!;
                              final text = dataRead[index - 1];
                              if (text.hasImage ?? false) {}
                              snapInfo.insert(0, text.data ?? "");
                              search.increase();
                            }
                          }
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: snapInfo.length,
                          // physics: const ScrollMotion(),
                          itemBuilder: (context, index) {
                            final da = snapInfo[index];
                            final refinedData = searchBloc.replace(da);
                            return Text(refinedData);
                          },
                        ),
                      ),
                    ),
                    Space().height(context, 0.09)
                  ],
                );
              }
              if (state is ReadDataLoaded) {
                final data = state.data;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: data?.length,
                        //  physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final das = data![index];
                          return DataAdd(
                              textEntity: das,
                              searchBloc: searchBloc,
                              isTextImage: das.hasImage);
                        },
                      ),
                    ),
                    Space().height(context, 0.09)
                  ],
                );
              }

              if (state is ReadDataDetailsLoaded) {
                final data = state.textEntity;
                return ReadDataGeneratedWidget(
                  searchBloc: searchBloc,
                  data: data?.data,
                  isTextImage: data?.hasImage,
                  title: data?.title,
                  dataImage: data?.dataImage,
                );
              }
              if (isSpeechTextEnabled) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Listening',
                      ),
                    ),
                    Text("${time.toString()} seconds"),
                  ],
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  SizedBox(
                        //   width: 300,
                        //    child: Row(
                        //      children: [
                        //        Text("Jerrito Gemini AIddhddhhdhdhdhhdhd",overflow: TextOverflow.ellipsis,
                        //           style: TextStyle(fontSize: 30),softWrap: true,),
                        //      ],
                        //    ),
                        //  ),

                        Space().height(context, 0.1),
                        Center(child: Lottie.asset(ai2Json)),
                      ]),
                );
              }
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await context.pushNamed("user");
                },
                child: Column(children: [
                  CircleAvatar(
                    backgroundImage: (profile != null ||
                            (user.profile?.isNotEmpty ?? false))
                        ? CachedNetworkImageProvider(profile ?? user.profile!)
                        : null,
                    child: (profile == null || (user.profile?.isEmpty ?? true))
                        ? Text(
                            user.userName?.substring(0, 2) ?? "NA",
                          )
                        : null,
                  ),
                  Space().height(context, 0.02),
                  Text(
                    user.userName ?? user.email ?? "",
                  ),
                ]),
              ),
              const Divider(
                thickness: 2,
              ),
              canDeleteData
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconGesture(
                          onTap: () {
                            canDeleteData = !canDeleteData;
                            ids.clear();
                            setState(() {});
                          },
                          icon: Icons.deselect_outlined,
                        ),
                        IconGesture(
                          onTap: () {
                            if (ids.isNotEmpty) {
                              final Map<String, dynamic> params = {
                                "token": token,
                                "list": ids
                              };
                              dataGeneratedBloc.add(
                                  DeleteListDataGeneratedEvent(params: params));
                            }
                          },
                          icon: Icons.delete,
                        ),
                        IconGesture(
                          onTap: () {
                            ids.addAll(allSelectIds);

                            setState(() {});
                          },
                          icon: Icons.check_box_outline_blank_rounded,
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Center(
                          child: Text("History",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline)),
                        ),
                        IconGesture(
                            onTap: () {
                              canDeleteData = !canDeleteData;
                              ids.clear();
                              setState(() {});
                            },
                            icon: Icons.checklist_outlined),
                      ],
                    ),
              BlocConsumer(
                bloc: dataGeneratedBloc,
                listener: (BuildContext context, Object? state) {
                  if (state is ReadDataError) {
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                  if (state is DeleteListDataGeneratedLoaded) {
                    ids.clear();
                    final data = state.isSuccess;
                    canDeleteData = !canDeleteData;
                    context.pop();
                    if (data) {
                      showSnackbar(
                          isSuccessMessage: true,
                          context: context,
                          message: "Successfuly deleted");
                    }
                  }
                  if (state is DeleteListDataGeneratedError) {
                    ids.clear();
                    final data = state.errorMessage;
                    context.pop();
                    showSnackbar(context: context, message: data);
                  }
                  if (state is ListDataGeneratedLoaded) {
                    final response = state.listData;
                    for (var i in response.dataIds) {
                      allSelectIds.add(i);
                    }
                    // print(allSelectIds);
                  }
                  if (state is ListDataGeneratedError) {
                    print(state.errorMessage);
                    // if (state.errorMessage !=
                    //     "Exception: {message: No data found, error: null, errorCode: 102}") {
                    //   context.pop();
                    //   showSnackbar(
                    //       context: context, message: state.errorMessage);
                    // }
                  }
                  if (state is DeleteDataGeneratedLoaded) {
                    context.pop();
                    if (state.isSuccess) {
                      showSnackbar(
                          isSuccessMessage: state.isSuccess,
                          context: context,
                          message: "Deleted succcessfully");
                    }
                  }
                  if (state is DeleteDataGeneratedError) {
                    context.pop();
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is ListDataGeneratedLoading ||
                      state is DeleteDataGeneratedLoading ||
                      state is DeleteListDataGeneratedLoading) {
                    return const HistoryShimmer();
                  }
                  if (state is ListDataGeneratedError) {
                    if (state.errorMessage ==
                        "Exception: {message: No data found, error: null, errorCode: 102}") {
                      return Lottie.asset(historyJson);
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                dataGeneratedBloc.add(ListDataGeneratedEvent(
                                    params: {"token": token}));
                              },
                              child: const Text("Retry")),
                        ],
                      );
                    }
                  }

                  if (state is ListDataGeneratedLoaded) {
                    final response = state.listData.data;
                    final firestoreId = state.listData.dataIds;
                    return response.isEmpty
                        ? Lottie.asset(historyJson)
                        : Flexible(
                            child: ListView.builder(
                              shrinkWrap: response.length > 7 ? false : true,
                              itemCount: response.isEmpty ? 0 : response.length,
                              itemBuilder: (context, index) {
                                final datas = response[index];
                                final docIds = firestoreId[index];
                                final params = {
                                  "token": token,
                                  "title": datas.title,
                                  "data": datas.data,
                                  "dataImage": datas.dataImage,
                                  "dateTime": datas.dateTime,
                                  "hasImage": datas.hasImage,
                                  "path": docIds,
                                };
                                return Slidable(
                                    // Specify a key if the Slidable is dismissible.
                                    key: const ValueKey(0),
                                    startActionPane: ActionPane(
                                      // A motion is a widget used to control how the pane animates.
                                      motion: const ScrollMotion(),
                                      children: [
                                        // A SlidableAction can have an icon and/or a label.
                                        SlidableActionWidget(
                                          onPressed: (context) async {
                                            await Share.share(
                                                (datas.title ?? "") +
                                                    (datas.data ?? ""));
                                            if (!context.mounted) return;
                                            context.pop();
                                          },
                                          isDeleteButton: false,
                                        ),

                                        SlidableActionWidget(
                                          onPressed: (context) async {
                                            dataGeneratedBloc.add(
                                                DeleteDataGeneratedEvent(
                                                    params: params));
                                            if (!context.mounted) return;
                                          },
                                          isDeleteButton: true,
                                        ),
                                      ],
                                    ),

                                    // The end action pane is the one at the right or the bottom side.
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableActionWidget(
                                          onPressed: (context) async {
                                            await Share.share(
                                                (datas.title ?? "") +
                                                    (datas.data ?? ""));
                                            if (!context.mounted) return;
                                            context.pop();
                                          },
                                          isDeleteButton: false,
                                        ),
                                        SlidableActionWidget(
                                          onPressed: (context) async {
                                            dataGeneratedBloc.add(
                                                DeleteDataGeneratedEvent(
                                                    params: params));
                                          },
                                          isDeleteButton: true,
                                        ),
                                      ],
                                    ),
                                    child: GeneratedDataTitle(
                                        onChanged: canDeleteData
                                            ? (value) {
                                                ids.contains(docIds)
                                                    ? ids.remove(docIds)
                                                    : ids.add(docIds);
                                                setState(() {});
                                                // print(ids);
                                              }
                                            : (value) {
                                                searchBloc.add(
                                                  ReadDataDetailsEvent(
                                                      params: params),
                                                );
                                                context.pop();
                                              },
                                        value: ids.contains(docIds),
                                        canDelete: canDeleteData,
                                        title: datas.title,
                                        imageUrl: datas.dataImage,
                                        hasImage: datas.hasImage,
                                        onLongPress: () {
                                          if (!canDeleteData) {
                                            canDeleteData = !canDeleteData;
                                            ids.contains(docIds)
                                                ? ids.remove(docIds)
                                                : ids.add(docIds);
                                            setState(() {});
                                          }
                                        },
                                        onTap: () {
                                          searchBloc.add(
                                            ReadDataDetailsEvent(
                                                params: params),
                                          );
                                          context.pop();
                                        }));
                              },
                            ),
                          );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DataAdd> datas = [];
  List<String> ids = [];
  List<String> allSelectIds = [];
}
