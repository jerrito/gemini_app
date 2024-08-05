// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/strngs.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/authentication/presentation/pages/otp_page.dart';
import 'package:gemini/locator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:string_validator/string_validator.dart';

class PhoneNumberPage extends StatefulWidget {
  final bool isLogin;
  final String? id, uid, oldNumberString;
  const PhoneNumberPage(
      {super.key,
      required this.isLogin,
      this.id,
      this.uid,
      this.oldNumberString});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final authBloc = sl<AuthenticationBloc>();
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  PhoneNumber phone = PhoneNumber();
  String number = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify Number"),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes().height(context, 0.01),
              vertical: Sizes().height(context, 0.02)),
          child: BlocConsumer(
            bloc: authBloc,
            listener: (context, state) async {
              if (state is CodeSent) {
                final data = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return OTPPage(
                      otpRequest: OTPRequest(
                          isLogin: widget.isLogin,
                          phoneNumber: number,
                          forceResendingToken: state.token,
                          verifyId: state.verifyId,
                          uid: widget.uid,
                          id: widget.id,
                          oldNumberString: widget.oldNumberString),
                    );
                  }),
                );
                if (data == "resend") {
                  authBloc.add(
                    PhoneNumberEvent(phoneNumber: number),
                  );
                }
              }
              if (state is CodeCompleted) {
                print("verification completed ${state.authCredential.smsCode}");
                // print(" ${authCredential.verificationId}");
                User? user = FirebaseAuth.instance.currentUser;

                if (state.authCredential.smsCode != null) {
                  try {
                    UserCredential credential =
                        await user!.linkWithCredential(state.authCredential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'provider-already-linked') {
                      final credential = await FirebaseAuth.instance
                          .signInWithCredential(state.authCredential);
                    }
                  }
                }
              }

              if (state is GenericError) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
              if (state is CheckPhoneNumberChangeError) {
                authBloc.add(
                  PhoneNumberEvent(phoneNumber: number),
                );
              }
              if (state is CheckPhoneNumberLoaded) {
                //if (state.isNumberChecked == true) {
                authBloc.add(
                  PhoneNumberEvent(phoneNumber: number),
                );
                // } else {
                //   if (!context.mounted) return;
                //   showSnackbar(
                //     context: context,
                //     message: "Entered number not equal to old number",
                //     isSuccessMessage: true,
                //   );
                // }
              }
              // if (state is CheckPhoneNumberChangeError) {
              //   if (!context.mounted) return;
              //   showSnackbar(
              //       context: context,
              //       message:state.errorMessage,
              //       isSuccessMessage: true,
              //     );

              // }
            },
            builder: (context, state) {
              if (state is VerifyPhoneNumberLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // if (state is CheckPhoneNumberChangeLoading) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              return DefaultButton(
                  label: "Validate",
                  onTap: () {
                    if (formKey.currentState?.validate() == true) {
                      if (widget.oldNumberString != null) {
                        Map<String, dynamic> params = {
                          "start_number": widget.oldNumberString,
                          "phone_number": number
                        };
                        authBloc.add(
                          CheckPhoneNumberEvent(params: params),
                        );
                      } else {
                        authBloc.add(
                          PhoneNumberEvent(phoneNumber: number),
                        );
                      }
                    }
                  });
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Space().height(context, 0.030),
              const Text(
                "Enter your number to get a verification message",
                textAlign: TextAlign.start,
              ),
              Space().height(context, 0.090),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // label
                  Text(widget.oldNumberString != null
                      ? "Enter Old Phone Number"
                      : "Enter Phone Number"),

                  // phone textfield
                  InternationalPhoneNumberInput(
                    onInputChanged: (value) {
                      number = value.phoneNumber!;
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
                  )
                ],
              ),
              Space().height(context, 0.030),
            ]),
          ),
        ));
  }
}
