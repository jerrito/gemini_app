import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_bottom_sheet.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:gemini/features/user/presentation/providers/user_provider.dart';
import 'package:gemini/features/user/presentation/widgets/user_profile.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart';

mixin UserProfileMixin {
  String? successMessage;
  buildUserDialog({
    required BuildContext context,
    required String? token,
    required String label,
    required String? data,
    required AuthenticationBloc authBloc,
  }) {
    final userBloc = sl<UserBloc>();
    final userProvider = context.read<UserProvider>();
    final controller = TextEditingController();
    final newPasswordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    (label != UserProfileData.password.name) ? controller.text = data! : null;
    final formKey = GlobalKey<FormState>();
    final formPasswordKey = GlobalKey<FormState>();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (
        context,
      ) =>
          SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Sizes().width(context, 0.02),
                  vertical: Sizes().height(context, 0.02)),
              title: Text("Edit $label"),
              children: [
            (label != UserProfileData.password.name)
                ? Form(
                    key: formKey,
                    child: FormField<String>(
                        initialValue: data,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          validateString.call(value);
                          if (label == "email") {
                            if (!isEmail(value!)) {
                              return "Not a valid email";
                            }
                          }
                          return null;
                        },
                        builder: (field) {
                          return DefaultTextFieldForm(
                            onChanged: (value) {
                              field.didChange(value);
                            },
                            errorText: field.errorText,
                            label: "Edit $label",
                            controller: controller,
                          );
                        }),
                  )
                : Form(
                    key: formPasswordKey,
                    child: Column(children: [
                      FormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: validatePassword,
                          builder: (field) {
                            return DefaultTextFieldForm(
                              onChanged: (value) {
                                field.didChange(value);
                              },
                              errorText: field.errorText,
                              label: "Enter old $label",
                              controller: oldPasswordController,
                            );
                          }),
                      FormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return "Field is required";
                            }
                            if (!value!.isLength(6)) {
                              return "Password must be 6 or more characters";
                            }
                            if (value != confirmPasswordController.text) {
                              return "confirm password don't match";
                            }

                            return null;
                          },
                          builder: (field) {
                            return DefaultTextFieldForm(
                              onChanged: (value) {
                                field.didChange(value);
                              },
                              errorText: field.errorText,
                              label: "Enter New Password",
                              controller: newPasswordController,
                            );
                          }),
                      FormField<String>(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return "Field is required";
                            }
                            if (!value!.isLength(6)) {
                              return "Password must be 6 or more characters";
                            }
                            if (value != newPasswordController.text) {
                              return "new password doesn't match";
                            }
                            return null;
                          },
                          builder: (field) {
                            return DefaultTextFieldForm(
                              onChanged: (value) {
                                field.didChange(value);
                              },
                              errorText: field.errorText,
                              label: "Confirm New Password",
                              controller: confirmPasswordController,
                            );
                          })
                    ]),
                  ),
            Space().height(context, 0.02),
            BlocConsumer(
                bloc: userBloc,
                listener: (context, state) {
                  if (state is ChangePasswordLoaded) {
                    context.pop();
                    showSnackbar(
                        isSuccessMessage: true,
                        context: context,
                        message: state.data);
                  }
                  if (state is ChangePasswordError) {
                    context.pop();
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                  if (state is UpdateUserLoaded) {
                    final data = state.user;
                    userProvider.user = data as dynamic;

                    context.pop();
                  }
                  if (state is UpdateUserError) {
                    context.pop();
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is UpdateUserLoading ||
                      state is ChangePasswordLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Sizes().width(context, 0.3),
                        child: DefaultButton(
                          label: "Cancel",
                          onTap: () {
                            context.pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: Sizes().width(context, 0.3),
                        child: DefaultButton(
                            label: "Update",
                            onTap: (label == UserProfileData.password.name)
                                ? () async {
                                    if (formPasswordKey.currentState!
                                        .validate()) {
                                      final params = {
                                        "oldPassword":
                                            oldPasswordController.text,
                                        "newPassword":
                                            newPasswordController.text,
                                        "confirmPassword":
                                            confirmPasswordController.text,
                                        "token": token
                                      };
                                      userBloc.add(
                                        ChangePasswordEvent(
                                          params: params,
                                        ),
                                      );
                                    }
                                  }
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      final params = {
                                        "queryParams": {label: controller.text},
                                        "token": token
                                      };
                                      userBloc.add(UpdateUserEvent(
                                        params: params,
                                      ));
                                    }
                                  }),
                      )
                    ],
                  );
                })
          ]),
    );
  }

  buildUserRemoveDialog(
          {required BuildContext context,
          required String? token,
          required String label,
          required AuthenticationBloc authBloc}) async =>
      await showModalBottomSheet(
        context: context,
        builder: (context) => Builder(builder: (context) {
          return StatefulBuilder(builder: (context, jerryState) {
            return DefaultBottomSheet(
              label: "Cancel",
              isLandingPage: false,
              onTap: () => context.pop(),
              profileWidget: BlocConsumer(
                listener: (listener, state) async {
                  if (state is DeleteAccountLoaded) {
                    final data = state.message;
                    jerryState(() {
                      successMessage = data;
                    });
                    final Map<String, dynamic> params = {};
                    authBloc.add(DeleteTokenEvent(params: params));
                  }

                  if (state is DeleteAccountError) {
                    context.pop();
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                  if (state is DeleteTokenError) {
                    if (!context.mounted) return;
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                  if (state is DeleteTokenLoaded) {
                    if (!context.mounted) return;
                    showSnackbar(
                        isSuccessMessage: true,
                        context: context,
                        message: successMessage ?? "");

                    context.goNamed("landing");
                  }
                  if (state is LogoutError) {
                    context.pop();
                    if (!context.mounted) return;
                    showSnackbar(
                      context: context,
                      message: state.errorMessage,
                    );
                  }
                  if (state is LogoutLoaded) {
                    final data = state.successMessage;
                    jerryState(() {
                      successMessage = data;
                    });

                    final Map<String, dynamic> params = {"refreshToken": null};
                    authBloc.add(
                      DeleteTokenEvent(
                        params: params,
                      ),
                    );
                  }
                },
                bloc: authBloc,
                builder: (context, state) {
                  if (state is DeleteAccountLoading || state is LogoutLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return TextButton(
                    onPressed: () async { 
                      //: TODO Add password dialog
                      final Map<String, dynamic> params = {
                        "token": token,
                        "body": {
                          "password": "112233"
                          // 112233   context.read<UserProvider>().user?.password
                        }
                      };
                      label == "deleteUser"
                          ? authBloc.add(
                              DeleteAccountEvent(
                                params: params,
                              ),
                            )
                          : authBloc.add(LogoutEvent(params: params));
                    },
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            );
          });
        }),
      );

  String? validateString(String? value) {
    if (value?.isEmpty ?? true) {
      return "Field is required";
    }
    if (!value!.isLength(2)) {
      return "Must be 2 or more characters";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty ?? false) {
      return "Field is required";
    }
    if (!value!.isLength(6)) {
      return "Password must be 6 or more characters";
    }

    return null;
  }
}

class _RowButtons extends StatelessWidget {
  final void Function()? onTap;
  const _RowButtons(this.onTap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: Sizes().width(context, 0.3),
          child: DefaultButton(
            label: "Cancel",
            onTap: () {
              context.pop();
            },
          ),
        ),
        SizedBox(
          width: Sizes().width(context, 0.3),
          child: DefaultButton(
            label: "Update",
            onTap: onTap,
          ),
        )
      ],
    );
  }
}
