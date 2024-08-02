import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/animations/animations.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with SingleTickerProviderStateMixin {
  final userBloc = sl<AuthenticationBloc>();
  late TokenProvider? tokenProvider;
  late UserProvider? userProvider;
  String? refreshToken;
  double opacity = 1.0;
  String? token;
  Animation? animation;
  late AnimationController animatedController;
  Color? color;
  // final colorTween=Ra

  @override
  void initState() {
    super.initState();
    animatedController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = ColorTween(begin: Colors.black, end: Colors.white)
        .animate(animatedController);
    animation?.addListener(() {
      setState(() {
        color = animation?.value;
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

    userBloc.add(
      GetTokenEvent(),
    );
  }

  @override
  void dispose() {
    animatedController.dispose();
    // animation?.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tokenProvider = context.read<TokenProvider>();
    userProvider = context.read<UserProvider>();
    //animatedController.forward();
    return Scaffold(
        bottomSheet: Container(
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Sizes().height(context, 0.6))),
          height: Sizes().height(context, 0.2),
          child: Column(
            children: [
              Center(
                child: Lottie.asset(aiJson,
                    width: Sizes().width(context, 0.3),
                    height: Sizes().height(context, 0.15)),
              ),
              Text(
                "Loading ...",
                style: TextStyle(color: color),
              )
            ],
          ),
        ),
        body: BlocConsumer(
          bloc: userBloc,
          listener: (context, state) {
            if (state is GetTokenLoaded) {
              refreshToken = state.authorization["refreshToken"];
              setState(() {});
              userBloc.add(
                RefreshTokenEvent(refreshToken: refreshToken!),
              );
            }
            if (state is RefreshTokenError) {
              if (state.errorMessage == "No internet connection") {
                context.goNamed("noInternet");
              } else {
                context.goNamed("signin");
              }
            }
            if (state is RefreshTokenLoaded) {
              tokenProvider?.setToken = state.token;
              final params = {"token": tokenProvider?.token};
              userBloc.add(
                GetUserEvent(
                  params: params,
                ),
              );
            }
            if (state is GetUserLoaded) {
              final user = state.user;
              userProvider?.user = user.user;
              context.goNamed("searchPage");
            }

            if (state is GetUserError) {
              context.goNamed("signin");
            }
            if (state is GetTokenError) {
              context.goNamed("landing");
            }
          },
          builder: (BuildContext context, Object? state) {
            return Image.asset(
              defaultImage,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            );
          },
        ));
  }
}
