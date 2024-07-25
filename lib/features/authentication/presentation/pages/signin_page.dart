import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/strngs.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final authBloc = sl<AuthenticationBloc>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  User? user;
  late UserProvider userProvider;
  late TokenProvider tokenProvider;
  String? accessToken, refreshToken;
  @override
  Widget build(BuildContext context) {
    final tokenProvider = context.read<TokenProvider>();
    final userProvider = context.read<UserProvider>();
    return Scaffold(
        appBar: AppBar(title: const Text("Signin")),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes().height(context, 0.01),
              vertical: Sizes().height(context, 0.02)),
          child: BlocConsumer(
            bloc: authBloc,
            listener: (context, state) {
              if (state is CacheTokenLoaded) {
                context.goNamed("searchPage");
              }
              if (state is CacheTokenError) {
                context.goNamed("connection");
              }
              if (state is SigninLoaded) {
                final userData = state.data.data.user;
                userProvider.user = userData;
                tokenProvider.setRefreshToken = state.data.data.refreshToken;
                tokenProvider.setToken=state.data.token;
                final authorization = {"refreshToken": state.data.data.refreshToken};
                authBloc.add(CacheTokenEvent(authorization: authorization));
              }
              if (state is SigninError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is SigninLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return DefaultButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final Map<String, dynamic> params = {
                        "email": emailController.text,
                        "password": passwordController.text
                      };
                      authBloc.add(SigninEvent(params: params));
                    }
                  },
                  label: "Signin");
            },
          ),
        ),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.04)),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Space().height(context, 0.1),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return fieldRequired;
                        }

                        if (!isEmail(
                          value!,
                        )) {
                          return mustBeEmail;
                        }

                        return null;
                      },
                      builder: (field) => DefaultTextFieldForm(
                          textInputType: TextInputType.emailAddress,
                          errorText: field.errorText,
                          onChanged: (value) => field.didChange(value),
                          controller: emailController,
                          hintText: "Enter Name or Email",
                          label: "UserName/Email"),
                    ),
                    Space().height(context, 0.02),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return fieldRequired;
                        }

                        if (!isLength(value!, 6)) {
                          return mustBeEmail;
                        }

                        return null;
                      },
                      builder: (field) => DefaultTextFieldForm(
                          errorText: field.errorText,
                          onChanged: (value) => field.didChange(value),
                          controller: passwordController,
                          hintText: "Enter Password",
                          label: "Password"),
                    ),
                    Space().height(context, 0.02),
                  ]),
            ),
          ),
        ));
  }
}
