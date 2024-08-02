import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/strngs.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/presentation/providers/token.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final authBloc = sl<AuthenticationBloc>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late UserProvider? userProvider;
  late TokenProvider? tokenProvider;
  String? refreshToken;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    userProvider = context.read<UserProvider>();
    tokenProvider = context.read<TokenProvider>();
    return Scaffold(
        appBar: AppBar(title: const Text("Signup")),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes().height(context, 0.01),
              vertical: Sizes().height(context, 0.02)),
          child: BlocConsumer(
            bloc: authBloc,
            listener: (context, state) {
              if (state is SignupError) {
                if (!context.mounted) return;
                showSnackbar(context: context, message: state.errorMessage);
              }
              if (state is CacheTokenLoaded) {
                context.goNamed("searchPage");
              }
              if (state is CacheTokenError) {
                context.goNamed("connection");
              }
              if (state is SignupLoaded) {
                final data = state.response.user;
                userProvider?.user = data;
                final refreshTokenResponse = state.response.user!.uid;
                tokenProvider?.setRefreshToken = refreshTokenResponse;
                tokenProvider?.setToken=state.response.user!.uid;
                final authorization = {"refreshToken": refreshTokenResponse};
                authBloc.add(CacheTokenEvent(authorization: authorization));
              }
            },
            builder: (context, state) {
              if (state is SignupLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return DefaultButton(
                  onTap: () {
                    if (formKey.currentState?.validate() == true) {
                      final Map<String, dynamic> params = {
                        "userName": nameController.text,
                        "email": emailController.text,
                        "password": passwordController.text,
                      };
                      authBloc.add(SignupEvent(params: params));
                    }
                  },
                  label: "Signup");
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
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Space().height(context, 0.03),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return fieldRequired;
                        }

                        if (!isLength(value!, 2)) {
                          return mustBePasswordCharacters;
                        }

                        return null;
                      },
                      builder: (field) => DefaultTextFieldForm(
                        errorText: field.errorText,
                        onChanged: (value) => field.didChange(value),
                        controller: nameController,
                        hintText: "Enter Username",
                        label: "UserName",
                      ),
                    ),
                    Space().height(context, 0.02),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
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
                        errorText: field.errorText,
                        textInputType: TextInputType.emailAddress,
                        onChanged: (value) => field.didChange(value),
                        controller: emailController,
                        hintText: "Enter Email",
                        label: "Email",
                      ),
                    ),
                    Space().height(context, 0.02),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return fieldRequired;
                        }

                        if (!isLength(value!, 6)) {
                          return mustBePasswordCharacters;
                        }

                        return null;
                      },
                      builder: (field) => DefaultTextFieldForm(
                        errorText: field.errorText,
                        isPassword: obscurePassword,
                        onChanged: (value) => field.didChange(value),
                        obscureText: obscureText,
                        suffixIcon: suffixIcon(),
                        controller: passwordController,
                        hintText: "Enter Password",
                        label: "Password",
                      ),
                    ),
                    Space().height(context, 0.02),
                  ]),
            ),
          ),
        ));
  }

  bool obscureText = true;
  bool obscurePassword = true;
  Widget suffixIcon() {
    return Visibility(
      visible: obscureText,
      replacement: GestureDetector(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: const Icon(
          Icons.close,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: const Icon(
          Icons.remove_red_eye,
        ),
      ),
    );
  }
}
