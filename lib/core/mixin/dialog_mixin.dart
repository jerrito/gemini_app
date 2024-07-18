import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
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

mixin Dialogs {
  buildDialog({
    required BuildContext context,
    required String? token,
    required String label,
    required String? data,
    required AuthenticationBloc authBloc,
  }) {
    final userBloc = sl<UserBloc>();
    final userProvider=context.read<UserProvider>();
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
                          return DefaultTextForm(
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
                            return DefaultTextForm(
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
                            return DefaultTextForm(
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
                            return DefaultTextForm(
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
            BlocListener(
              bloc: authBloc,
              listener: (context, state) {
                if (state is CacheUserDataLoaded) {
                  context.pop();
                  showSnackbar(
                      isSuccessMessage: true,
                      context: context,
                      message: "$label updated");
                }
                if (state is CacheUserDataError) {
                  showSnackbar(context: context, message: state.errorMessage);
                }
              },
              child: BlocConsumer(
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
                      showSnackbar(
                          context: context, message: state.errorMessage);
                    }
                    if (state is UpdateUserLoaded) {
                      final data = state.user;
                      userProvider.user=data;
                      context.pop();
                    }
                    if (state is UpdateUserError) {
                      context.pop();
                      showSnackbar(
                          context: context, message: state.errorMessage);
                    }
                  },
                  builder: (context, state) {
                    if (state is UpdateUserLoading ||
                        state is ChangePasswordLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _RowButtons(
                      onTap: (label == UserProfileData.password.name)
                          ? () async {
                              if (formPasswordKey.currentState!.validate()) {
                                final params = {
                                  "oldPassword": oldPasswordController.text,
                                  "newPassword": newPasswordController.text,
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
                            },
                    );
                  }),
            )
          ]),
    );
  }

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
  const _RowButtons({this.onTap});

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
