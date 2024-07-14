import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/assets/animations/animations.dart';
import 'package:gemini/assets/images/images.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/features/authentication/presentation/provders/token.dart';
import 'package:gemini/features/authentication/presentation/provider/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
  Animation<double>? opacityAnimation;

  @override
  void initState() {
    super.initState();
    final animatedController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    userBloc.add(
      GetTokenEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    tokenProvider = context.read<TokenProvider>();
    userProvider = context.read<UserProvider>();
    return Scaffold(
        bottomSheet: SizedBox(
          height: Sizes().height(context, 0.2),
          child: Column(
            children: [
              Center(
                child: Lottie.asset(aiJson,
                    width: Sizes().width(context, 0.3),
                    height: Sizes().height(context, 0.15)),
              ),
              AnimatedOpacity(
                onEnd: () {
                  opacity = 0;
                  setState(() {});
                  Future.delayed(Durations.short3, () {
                    opacity = 1;
                  });
                },
                opacity: opacity,
                duration: const Duration(seconds: 3),
                curve: Curves.decelerate,
                child: Text("Loading ..."),
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
              print("sgs${state.errorMessage}");
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
              userProvider?.user = user;
              context.goNamed("searchPage");
            }

            if (state is GetUserError) {
              print(state.errorMessage);
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
