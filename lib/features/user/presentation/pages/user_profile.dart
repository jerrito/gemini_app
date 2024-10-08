import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
// import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/core/mixin/dialog_mixin.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/features/user/presentation/widgets/remove_user.dart';
import 'package:gemini/features/user/presentation/widgets/show_image_pick.dart';
import 'package:gemini/features/user/presentation/widgets/user_profile.dart';
import 'package:gemini/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with UserProfileMixin {
  final authBloc = sl<AuthenticationBloc>();
  final userBloc = sl<UserBloc>();
  UserProvider? userProvider;
  late TokenProvider tokenProvider;
  late User user;
  String? token, email, userName, profile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().user!;
    userProvider = context.watch<UserProvider>();
    token = context.read<TokenProvider>().token ?? "";
    listUserData.setAll(
      0,
      [
        user.userName,
        user.email,
        "Change Password",
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Space().height(context, 0.05),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: (userProvider?.profile != null ||
                              (user.profile?.isNotEmpty ??
                                  user.profile != null))
                          ? CachedNetworkImageProvider(
                              userProvider?.profile ?? user.profile!)
                          : Image.asset(defaultImage).image,
                      radius: Sizes().height(context, 0.06),
                    ),
                    BlocConsumer(
                        listener: (context, state) {
                          if (state is UpdateProfileLoaded) {
                            profile = state.profile;
                            userProvider?.profileUpdate = profile!;
                          }
                          if (state is UpdateProfileError) {
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
                        await buildUserDialog(
                            context: context,
                            data: listUserData[index] ?? "",
                            label: listProfileData[index].name,
                            token: token,
                            authBloc: authBloc);
                      },
                      label: listUserData[index] ?? "",
                    ),
                  ),
                ),
                UserProfileWidget(
                  label: user.phoneNumber ?? "",
                  onTap: () => context.pushNamed("number",
                      queryParameters: {"oldNumberString": user.phoneNumber}),
                  userProfileData: UserProfileData.phoneNumber,
                ),
                Column(
                  children: List<RemoveUser>.of(
                    removeUser.entries.map((e) => RemoveUser(
                          onTap: () async {
                            await buildUserRemoveDialog(
                              authBloc: authBloc,
                              context: context,
                              token: token,
                              label: e.value.name,
                            );
                          },
                          removeData: e.value,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final removeUser = {
    "logOut": RemoveData.logOut,
    "deleteAccount": RemoveData.deleteUser,
  };
  List<String?> listUserData = ["", "", ""];
  List<UserProfileData> listProfileData = [
    UserProfileData.userName,
    UserProfileData.email,
    UserProfileData.password,
  ];
}
