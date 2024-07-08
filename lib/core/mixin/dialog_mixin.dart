import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:gemini/features/user/presentation/widgets/user_profile.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';

mixin Dialogs {
  buildDialog({
    required BuildContext context,
    required String? token,
    required String label,
    required String? data,
    required AuthenticationBloc authBloc,
  }) {
    final userBloc = sl<UserBloc>();
    final controller = TextEditingController();
    final newPasswordcontroller = TextEditingController();
    final oldPasswordcontroller = TextEditingController();
    final confirmPasswordcontroller = TextEditingController();
    (label != UserProfileData.password.name) ? controller.text = data! : null;
    final formKey = GlobalKey<FormState>();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (
        context,
      ) =>
          Form(
        key: formKey,
        child: SimpleDialog(
            contentPadding: EdgeInsets.symmetric(
                horizontal: Sizes().width(context, 0.02),
                vertical: Sizes().height(context, 0.02)),
            title: Text("Edit $label"),
            children: [
              (label != UserProfileData.password.name)
                  ? DefaultTextForm(
                      label: "Edit $label",
                      controller: controller,
                    )
                  : Column(children: [
                      DefaultTextForm(
                        label: "Enter old $label",
                        controller: oldPasswordcontroller,
                      ),
                      DefaultTextForm(
                        label: "Enter New Password",
                        controller: newPasswordcontroller,
                      ),
                      DefaultTextForm(
                        label: "Confirm New Password",
                        controller: confirmPasswordcontroller,
                      )
                    ]),
              Space().height(context, 0.02),
              BlocListener(
                bloc: authBloc,
                listener: (context, state) {
                  if (state is CacheUserDataLoaded) {
                    context.pop();
                  }
                  if (state is CacheUserDataError) {
                    showSnackbar(context: context, message: state.errorMessage);
                  }
                },
                child: BlocConsumer(
                    listener: (context, state) {
                      if (state is UpdateUserLoaded) {
                        final data = state.user;
                        final Map<String, dynamic> params = {
                          "userName": data.userName,
                          "email": data.email,
                          "profile": data.profile
                        };
                        authBloc.add(
                          CacheUserDataEvent(
                            params: params,
                          ),
                        );
                      }
                      if (state is UpdateUserError) {
                        context.pop();
                        print(state.errorMessage);
                        showSnackbar(
                            context: context, message: state.errorMessage);
                      }
                    },
                    bloc: userBloc,
                    builder: (context, state) {
                      if (state is UpdateUserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return RowButtons(
                        onTap: () async {
                          final params = {
                            "userName": controller.text,
                            "token": token
                          };
                          print(params);
                          userBloc.add(
                            UpdateUserEvent(
                              params: params,
                            ),
                          );
                        },
                      );
                    }),
              )
            ]),
      ),
    );
  }
}

class RowButtons extends StatelessWidget {
  final void Function()? onTap;
  const RowButtons({super.key, this.onTap});

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
