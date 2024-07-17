import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/core/mixin/dialog_mixin.dart';
import 'package:gemini/features/authentication/presentation/provders/token.dart';
import 'package:gemini/features/authentication/presentation/provider/user_provider.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:gemini/features/user/presentation/widgets/show_image_pick.dart';
import 'package:gemini/features/user/presentation/widgets/user_profile.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with Dialogs {
  final authBloc = sl<AuthenticationBloc>();
  final userBloc = sl<UserBloc>();
  late UserProvider userProvider;
  late TokenProvider tokenProvider;
  late User user;
  String? token, email, userName, successMessage, profile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().user!;
    token = context.watch<TokenProvider>().token!;
    listUserData.setAll(
      0,
      [user.userName, user.email, "Change Password"],
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
        child: BlocListener(
          bloc: authBloc,
          listener: (context, state) {
            if (state is LogoutLoaded) {
              final data = state.successMessage;
              successMessage = data;

              setState(() {});
              final Map<String, dynamic> params = {"refreshToken": null};
              authBloc.add(
                CacheTokenEvent(
                  authorization: params,
                ),
              );
            }
            if (state is CacheTokenError) {
              if (!context.mounted) return;
              showSnackbar(context: context, message: state.errorMessage);
            }
            if (state is CacheTokenLoaded) {
              if (!context.mounted) return;
              showSnackbar(
                  isSuccessMessage: true,
                  context: context,
                  message: successMessage!);

              context.goNamed("landing");
            }
            if (state is LogoutError) {
              if (!context.mounted) return;
              showSnackbar(context: context, message: state.errorMessage);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Space().height(context, 0.05),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: (profile != null &&
                              (userProvider.user!.profile!.isNotEmpty ||
                                  userProvider.user?.profile != null))
                          ? Image.network(
                                  fit: BoxFit.cover,
                                  profile ?? userProvider.user!.profile!)
                              .image
                          : Image.asset(defaultImage).image,
                      radius: Sizes().height(context, 0.06),
                    ),
                    BlocConsumer(
                        listener: (context, state) {
                          if (state is UpdateProfileLoaded) {
                            profile = state.profile;
                            setState(() {});
                          }
                          if (state is UpdateProfileError) {
                            print(state.errorMessage);
                            showSnackbar(
                                context: context, message: state.errorMessage);
                          }
                        },
                        bloc: userBloc,
                        builder: (context, state) {
                          if (state is UpdateProfileLoading) {
                            return const CircularProgressIndicator();
                          }
                          return CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: IconButton(
                              onPressed: () async {
                                final Uint8List? imageBuffer =
                                    await buildPickImage(
                                  context: context,
                                );
                                if (imageBuffer != null) {
                                  final params = {
                                    "dataImage": imageBuffer,
                                    "token": token
                                  };
                                  userBloc
                                      .add(UpdateProfileEvent(params: params));
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                          );
                        })
                  ],
                ),
                Space().height(context, 0.05),
                Column(
                  children: List.generate(
                    listProfileData.length,
                    (int index) => UserProfileWidget(
                      userProfileData: listProfileData[index],
                      onTap: () async {
                        await buildDialog(
                            context: context,
                            data: listUserData[index] ?? "",
                            label: listProfileData[index].name,
                            token: token,
                            authBloc: authBloc);
                        // authBloc.add(GetUserCacheDataEvent());
                      },
                      label: listUserData[index] ?? "",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final Map<String, dynamic> params = {"token": token};
                    authBloc.add(LogoutEvent(params: params));
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String?> listUserData = ["", "", ""];
  List<UserProfileData> listProfileData = [
    UserProfileData.userName,
    UserProfileData.email,
    UserProfileData.password
  ];
}
