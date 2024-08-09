import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
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
  final phoneNumberController = TextEditingController();
  String newNumber = "", confirmNumber = "";
  PhoneNumber phone = PhoneNumber();

  @override
  void initState() {
    phone = PhoneNumber(
      phoneNumber: widget.oldPhoneNumber,
      isoCode: "Gh",
      dialCode: "+233",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Number"),
      ),
      bottomSheet: BlocConsumer(
          bloc: authBloc,
          listener: (context, state) {
            if (state is CheckPhoneNumberLoaded) {
              final Map<String, dynamic> params = {
                "phoneNumber": newNumber,
              };
              authBloc.add(
                GetUserEvent(
                  params: params,
                ),
              );
            }
            if (state is GetUserError) {
              showSnackbar(
                context: context,
                message: state.errorMessage,
              );
            }
            if (state is GetUserLoaded) {
              userProvider.user = state.user;
              context.goNamed("searchPage");
            }
          },
          builder: (context, state) {
            return DefaultButton(
                label: "Validate",
                onTap: () {
                  if (formKey.currentState?.validate() == true) {
                    Map<String, dynamic> params = {
                      "start_number": widget.oldPhoneNumber,
                      "phone_number": newNumber
                    };
                    authBloc.add(
                      CheckPhoneNumberEvent(params: params),
                    );
                  }
                });
          }),
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

              Space().height(context, 0.02),
              // New phone number
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
                textFieldController: phoneNumberController,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),

              Space().height(context, 0.02),
              // confirm phone number
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
                textFieldController: phoneNumberController,
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
