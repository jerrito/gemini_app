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
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ChangeNumber extends StatefulWidget {
  final String oldPhoneNumber;
  const ChangeNumber({super.key, required this.oldPhoneNumber});
  @override
  State<ChangeNumber> createState() => _ChangeNumber();
}

class _ChangeNumber extends State<ChangeNumber> {
  final formKey = GlobalKey<FormState>();
  final authBloc = sl<AuthenticationBloc>();
  final userBloc = sl<UserBloc>();
  final phoneNumberController = TextEditingController();
  String newNumber = "", confirmNumber = "";
  PhoneNumber phone = PhoneNumber(
    isoCode: "GH",
    dialCode: "+233",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Number"),
      ),
      bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes().width(context, 0.04),
          ),
          child: BlocListener(
            bloc: authBloc,
            listener: (context, state) {
              if (state is CheckPhoneNumberLoaded) {
                final Map<String, dynamic> params = {
                  "queryParams": {"phoneNumber": newNumber},
                };
                userBloc.add(
                  UpdateUserEvent(
                    params: params,
                  ),
                );
              }

              if (state is CheckPhoneNumberChangeError) {
                showSnackbar(
                  context: context,
                  message: "Numbers not equal",
                );
              }
            },
            child: BlocConsumer(
                bloc: userBloc,
                listener: (context, state) {
                  if (state is UpdateUserLoaded) {
                    userProvider.user = state.user;
                    context.goNamed("searchPage");
                  }
                  if (state is UpdateUserError) {
                    showSnackbar(
                      context: context,
                      message: state.errorMessage,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetUserLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return DefaultButton(
                      label: "Change",
                      onTap: () {
                        if (formKey.currentState?.validate() == true) {
                          Map<String, dynamic> params = {
                            "start_number": newNumber,
                            "phone_number": confirmNumber
                          };
                          authBloc.add(
                            CheckPhoneNumberEvent(params: params),
                          );
                        }
                      });
                }),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes().width(
            context,
            0.04,
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // old phone number
              FormField(
                enabled: false,
                builder: (field) => DefaultTextFieldForm(
                  label: "Entered Old Number",
                  enabled: false,
                  initialValue: widget.oldPhoneNumber,
                ),
              ),

              Space().height(context, 0.03),
              // New phone number
              const Text("New Phone Number"),
              InternationalPhoneNumberInput(
                onInputChanged: (value) {
                  newNumber = value.phoneNumber!;
                  setState(() {});
                },
                onInputValidated: (bool v) {
                  print(v);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                inputBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Sizes().height(context, 0.01)),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                initialValue: phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),

              Space().height(context, 0.03),
              // confirm phone number
              const Text("Confirm Phone Number"),
              InternationalPhoneNumberInput(
                onInputChanged: (value) {
                  confirmNumber = value.phoneNumber!;
                  setState(() {});
                },
                onInputValidated: (bool v) {
                  print(v);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                inputBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Sizes().height(context, 0.01)),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                initialValue: phone,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),

              Space().height(context, 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
