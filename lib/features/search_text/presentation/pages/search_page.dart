import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/animations/animations.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/core/widgets/bottom_sheet.dart';
import 'package:gemini/features/authentication/presentation/provders/token.dart';
import 'package:gemini/features/data_generated/presentation/bloc/data_generated_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/data_add.dart';
import 'package:gemini/features/search_text/presentation/widgets/generated_data_title.dart';
import 'package:gemini/features/search_text/presentation/widgets/read_data_generated.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/bloc/search_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/history_shimmer.dart';
import 'package:gemini/features/search_text/presentation/widgets/search_type.dart';
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

class _SearchTextPage extends State<SearchTextPage> {
  final searchBloc = sl<SearchBloc>();
  final dataGeneratedBloc = sl<DataGeneratedBloc>();
  final searchBloc2 = sl<SearchBloc>();
  final ScrollController _scrollController = ScrollController();
  final searchBloc3 = sl<SearchBloc>();
  final authBloc = sl<AuthenticationBloc>();

  final form = GlobalKey<FormState>();
  List<Uint8List> all = [];
  List<Uint8List> newAll = [];
  List<String> imageExtensions = [];
  int imageLength = 0;

  List<String> snapInfo = [];
  String info = "How can I help you today?";
  int type = RequestType.stream.value;
  bool isTextImage = false;
  bool isAdded = false;
  bool canDeleteData = false;
  String? question, refinedData, email, userName, token;
  String repeatQuestion = "";
  String name = "";
  String joinedSnapInfo = "";
  String initText = "";
  final controller = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TokenProvider? tokenProvider;
  Uint8List? byte;
  bool isAvailable = false;
  bool isSpeechTextEnabled = false;

  getTime() {
    Timer.periodic(const Duration(seconds: 90), (timer) {
      // print(timer.tick);
    });
  }

  Future<List<TextEntity>?> remove() async {
    return await searchBloc.readData();
  }

  @override
  void initState() {
    super.initState();
    initText = controller.text;
    searchBloc2.add(ReadSQLDataEvent());
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

  void execute(
      {required TextEntity textEntity,
      required int eventType,
      bool? isTextImage}) async {
    searchBloc2.add(ReadAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    token = context.read<TokenProvider>().token;
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

                scaffoldKey.currentState?.openDrawer();

                authBloc.add(GetUserCacheDataEvent());
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
                }
                if (state is StopSpeechTextLoaded) {
                  setState(() {
                    isSpeechTextEnabled = !isSpeechTextEnabled;
                  });
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
                if (isTextImage) {
                  if (all.isEmpty) {
                    return "image is required";
                  }
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
                        switch (type) {
                          case 4:
                            searchBloc.add(
                              SearchTextEvent(
                                params: params,
                              ),
                            );
                            break;

                          case 3:
                            searchBloc.add(
                              ChatEvent(
                                params: params,
                              ),
                            );
                            break;

                          case 2:
                            searchBloc.add(
                              SearchTextAndImageEvent(
                                params: paramsWithImage,
                              ),
                            );
                            break;
                          case 1:
                            searchBloc.add(
                              GenerateStreamStopEvent(
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
                if (state is AddMultipleImageLoading) {}
                if (state is ReadDataLoaded) {
                  print(state.data?.length);
                  print("loaded");
                  final data = state.data;
                  searchBloc2.add(DeleteDataEvent(params: data));
                }
              },
            ),
            BlocListener(
              bloc: dataGeneratedBloc,
              listener: (context, state) {
                if (state is DataGeneratedLoaded) {
                  print("dd");
                }
                if (state is DataGeneratedError) {
                  print("ss${state.errorMessage}");
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
                if (state is DataGeneratedLoading) {
                  searchBloc.add(ReadSQLDataEvent());
                }
              },
            ),
          ],
          child: BlocConsumer(
            bloc: searchBloc,
            listener: (context, state) async {
              if (state is ReadDataLoaded) {
                print("load");

                // searchBloc.add(ReadAllEvent());
                _scrollDown();
              }
              // if (state is DeleteDataLoaded) {
              //   print("object");
              // }
              // if (state is DeleteDataError) {
              // }
              // if (state is ReadDataError) {
              //   // final error = state.errorMessage;
              // }

              if (state is SearchTextLoaded) {
                question = controller.text;
                controller.text = "";
                isAvailable = false;
                final newId = await searchBloc.readData();
                final data = state.data;
                refinedData = searchBloc.replace(data);
                Map<String, dynamic> params = {
                  "token": token,
                  "textId": newId!.isNotEmpty ? newId.last.textId + 1 : 1,
                  "title": (question!.isNotEmpty ? question! : repeatQuestion),
                  "data": refinedData,
                  "dateTime": DateTime.now().toString(),
                  "eventType": 4,
                  "hasImage": false
                };
                await searchBloc.addData(params);
                dataGeneratedBloc.add(DataEvent(params: params));
              }
              if (state is ChatLoaded) {
                question = controller.text;
                controller.text = "";
                isAvailable = false;
                final newId = await searchBloc.readData();
                print(newId![0]);
                final data = state.data;
                refinedData = searchBloc.replace(data);
                Map<String, dynamic> params = {
                  "token": token,
                  "textId": newId.isNotEmpty ? newId.last.textId + 1 : 1,
                  "title": (question!.isNotEmpty ? question! : repeatQuestion),
                  "data": refinedData,
                  "dateTime": DateTime.now().toString(),
                  "eventType": 3,
                };
                await searchBloc.addData(params);
                dataGeneratedBloc.add(DataEvent(params: params));
              }
              if (state is GenerateStreamLoading) {
                question = controller.text;
                controller.text = "";
                setState(() {});
              }
              if (state is SearchTextAndImageLoaded) {
                print(byte);
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
                  "dateTime": DateTime.now().toString(),
                  "eventType": 2,
                  "hasImage": true,
                  "dataImage": byte
                };
                isAdded = false;
                isTextImage = true;
                setState(() {});
                await searchBloc.addData(params);
                dataGeneratedBloc.add(DataEvent(params: params));
              }

              if (state is ReadAll) {
                final textEntity = data!.last;
                // data=state.data;
                // setState(() {});
                final params = {
                  "token": token,
                  "data": textEntity.data?.replaceAll("\n", ""),
                  "title": textEntity.title,
                  "dataImage": textEntity.dataImage,
                  "hasImage": textEntity.hasImage
                };
                _scrollDown();
                // searchBloc.add(DataEvent(params: params));
              }
              if (state is GenerateContentAllDone) {
                question = controller.text;
                controller.text = "";
                isAvailable = false;
                final newId = await searchBloc.readData();
                final data = state.data;
                refinedData = searchBloc.replace(data);
                Map<String, dynamic> params = {
                  "token": token,
                  "textId": newId!.isNotEmpty ? newId.last.textId + 1 : 1,
                  "title": (question!.isNotEmpty ? question! : repeatQuestion),
                  "data": refinedData,
                  "dateTime": DateTime.now().toString(),
                  "eventType": 1,
                  "hasImage": false,
                  "dataImage": null
                };
                await searchBloc.addData(params);
                dataGeneratedBloc.add(DataEvent(params: params));
              }
              if (state is GenerateContentLoaded) {
                final data = state.data;
                isAvailable = false;
                print("added");
                setState(() {});
                snapInfo.add(data.toString());
                _scrollDown();
              }

              if (state is GenerateContentError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
              if (state is SearchTextAndImageError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
              if (state is SearchTextError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
              if (state is ChatError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is SearchTextAndImageLoading ||
                  state is SearchTextLoading ||
                  state is ChatLoading ||
                  state is ReadDataLoading ||
                  state is GenerateContentLoading) {
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
                final data = state.data;

                return Column(
                  children: [
                    // Text(question!.isNotEmpty ? question! : repeatQuestion),
                    Space().height(context, 0.01),
                    Flexible(
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: snapInfo.length,
                        // physics: const ScrollMotion(),
                        itemBuilder: (context, index) {
                          final da = snapInfo[index];
                          final allRefined = searchBloc.replace(da);
                          return Text(allRefined);
                        },
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
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Listening',
                      ),
                    ),
                    Text("00:01"),
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
              BlocListener(
                bloc: authBloc,
                listener: (context, state) async {
                  if (state is GetUserCachedDataLoaded) {
                    final data = state.data;
                    email = data["email"];
                    userName = data["userName"];
                    canDeleteData = false;
                    setState(() {});
                    dataGeneratedBloc.add(
                      ListDataGeneratedEvent(
                        params: {"token": token},
                      ),
                    );
                  }
                  if (state is GetUserCacheDataError) {
                    canDeleteData = false;
                    setState(() {});
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await context.pushNamed("user");
                        },
                        child: CircleAvatar(
                          child: Text(
                            userName?.substring(0, 1).toUpperCase() ??
                                email?.substring(0, 1).toUpperCase() ??
                                "",
                          ),
                        ),
                      ),
                      Text(
                        userName ?? email ?? "",
                      ),
                    ]),
              ),
              SearchTypeWidget(
                value: type,
                type: RequestType.stream,
                onTap: () {
                  type = RequestType.stream.value;
                  RequestType.stream;
                  isTextImage = false;
                  isAdded = false;
                  context.pop();
                  setState(() {});
                },
              ),
              SearchTypeWidget(
                value: type,
                type: RequestType.textImage,
                onTap: () {
                  type = RequestType.textImage.value;
                  RequestType.textImage;
                  isTextImage = true;
                  isAdded = false;
                  context.pop();
                  setState(() {});
                },
              ),
              SearchTypeWidget(
                value: type,
                type: RequestType.chat,
                onTap: () async {
                  type = RequestType.chat.value;
                  RequestType.chat;
                  isTextImage = false;
                  isAdded = false;
                  context.pop();
                  setState(() {});
                },
              ),
              SearchTypeWidget(
                  value: type,
                  onTap: () async {
                    type = RequestType.future.value;
                    isTextImage = false;
                    isAdded = false;
                    context.pop();
                    setState(() {});
                  },
                  type: RequestType.future),
              const Divider(
                thickness: 2,
              ),
              canDeleteData
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            canDeleteData = !canDeleteData;
                            ids.clear();
                            print(ids);
                            setState(() {});
                          },
                          child: const Icon(Icons.deselect_outlined),
                        ),
                        GestureDetector(
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
                          child: const Icon(Icons.delete),
                        ),
                        GestureDetector(
                          onTap: () {
                            ids.addAll(allSelectIds);

                            print(ids);
                            setState(() {});
                          },
                          child: const Icon(Icons.check_box_outline_blank_rounded),
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
                        IconButton(
                            onPressed: () {
                              canDeleteData = !canDeleteData;
                              ids.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.checklist_outlined)),
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
                    print(data);
                    showSnackbar(context: context, message: data);
                  }
                  if (state is ListDataGeneratedLoaded) {
                    final response = state.listData;
                    for (var i in response) {
                      allSelectIds.add(i.id);
                    }
                    print(allSelectIds);
                  }
                  if (state is ListDataGeneratedError) {
                    context.pop();
                    showSnackbar(context: context, message: state.errorMessage);
                    print(state.errorMessage);
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
                    //  print("dd");
                    return const HistoryShimmer();
                  }

                  if (state is ListDataGeneratedLoaded) {
                    // ids.clear();
                    final response = state.listData;
                    return response.isEmpty
                        ? Lottie.asset(historyJson)
                        : Flexible(
                            child: ListView.builder(
                              // controller: _scrollController,
                              shrinkWrap: response.length > 7 ? false : true,
                              itemCount: response.isEmpty ? 0 : response.length,
                              itemBuilder: (context, index) {
                                final datas = response[index];
                                final params = {
                                  "token": token,
                                  "textId": datas.id,
                                  "title": datas.title,
                                  "data": datas.data,
                                  "dataImage": datas.dataImage,
                                  "eventType": datas.id,
                                  "dateTime": datas.id,
                                  "hasImage": datas.hasImage,
                                  "path": datas.id,
                                  "id": datas.id,
                                  "userId": datas.userId
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
                                            await dataGeneratedBloc
                                                .deleteDataGenerated(params);
                                          },
                                          isDeleteButton: true,
                                        ),
                                      ],
                                    ),
                                    child: GeneratedDataTitle(
                                        onChanged: canDeleteData
                                            ? (value) {
                                                print(ids);
                                                print(datas.id);
                                                ids.contains(datas.id)
                                                    ? ids.remove(datas.id)
                                                    : ids.add(datas.id);
                                                print(ids);
                                                setState(() {});
                                              }
                                            : (value) {
                                                searchBloc.add(
                                                  ReadDataDetailsEvent(
                                                      params: params),
                                                );
                                                context.pop();
                                              },
                                        value: ids.contains(datas.id),
                                        canDelete: canDeleteData,
                                        title: datas.title,
                                        onLongPress: () {
                                          if (!canDeleteData) {
                                            canDeleteData = !canDeleteData;
                                            print(ids);
                                            ids.contains(datas.id)
                                                ? ids.remove(datas.id)
                                                : ids.add(datas.id);
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
  List<int> ids = [];
  List<int> allSelectIds = [];
}

enum RequestType {
  stream(
      label: "Stream content",
      icon: Icons.stream,
      color: Colors.green,
      value: 1),
  textImage(
      label: "Search text with image",
      icon: Icons.image_search_outlined,
      color: Colors.green,
      value: 2),
  chat(label: "Chat with bot", icon: Icons.chat, color: Colors.green, value: 3),
  future(
      label: "Await content",
      icon: Icons.text_format,
      color: Colors.green,
      value: 4);

  final String label;
  final IconData? icon;
  final Color? color;
  final int value;

  const RequestType(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});
}
