import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/core/mixin/dialog_mixin.dart';
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
  String? token, email, userName, successMessage, profile;
  @override
  void initState() {
    super.initState();
    authBloc.add(GetUserCacheDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final data = {
      "userName": UserProfileData.userName,
      "email": UserProfileData.email,
      "password": UserProfileData.password,
    };
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
        child: MultiBlocListener(
          listeners: [
            BlocListener(
              bloc:userBloc,
              listener: (context,state){
              
            }),            
            BlocListener(
              bloc: authBloc,
              listener: (context, state) {
                if (state is GetUserCachedDataLoaded) {
                  final data = state.data;
                  listUserData.add(data["userName"]);
                  listUserData.add(data["email"]);
                  listUserData.add(data["password"]);

                  authBloc.add(GetTokenEvent());
                }
                if (state is LogoutLoaded) {
                  final data = state.successMessage;
                  successMessage = data;
                  setState(() {});
                  final Map<String, dynamic> params = {
                    "token": null,
                    "refreshToken": null
                  };
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
                if (state is GetUserCacheDataError) {
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
                if (state is GetTokenLoaded) {
                  token = state.authorization["token"];
                  setState(() {});
                }
                if (state is GetTokenError) {
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
                if (state is LogoutError) {
                  if (!context.mounted) return;
                  showSnackbar(context: context, message: state.errorMessage);
                }
              },
            ),
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: Image.network(
                      fit: BoxFit.cover,
                      "https://tbcdn.talentbrew.com/company/22348/cms/images/pages/cabin-crew/20230907_ba_england_womens_rugby_ba_group_tail_0330_em2.jpg",
                    ).image,
                    radius: Sizes().height(context, 0.06),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: IconButton(
                      onPressed: () async {
                        final imageData = await buildPickImage(
                          context: context,
                        );
                        if (imageData != null) {
                          print(imageData.toString()); 
                          final params = {
                            "data": imageData,
                          };
                         // userBloc.add(PickImageEvent(params: params));
                        }
                      },
                      icon:const Icon(Icons.image),
                    ),
                  )
                ],
              ),
              Column(
                children: List.generate(
                  listProfileData.length,
                  (int index) => UserProfileWidget(
                    userProfileData: listProfileData[index],
                    onTap: () async {
                      await buildDialog(
                          context: context,
                          label: "userName",
                          token: token,
                          authBloc: authBloc);
                      authBloc.add(GetUserCacheDataEvent());
                    },
                    label: "",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print(token);
                  final Map<String, dynamic> params = {"token": token};
                  authBloc.add(LogoutEvent(params: params));
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String?> listUserData = [];
  List<UserProfileData> listProfileData = [
    UserProfileData.userName,
    UserProfileData.email,
    UserProfileData.password
  ];

  List<void Function()> onTaps = [() {}, () {}, () {}];
}
