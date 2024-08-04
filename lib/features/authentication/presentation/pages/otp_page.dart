// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/search_text/presentation/widgets/show_snack.dart';
import 'package:gemini/locator.dart';
import 'package:go_router/go_router.dart';

//import 'package:house_rental_admin/src/home/presentation/pages/home_page.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pinput/pinput.dart';
import 'package:telephony/telephony.dart';

class OTPRequest {
  String? verifyId, phoneNumber, id, uid, oldNumberString;
  int? forceResendingToken;
  bool isLogin;
  //void Function()? onSuccessCallback;

  OTPRequest({
    this.verifyId,
    this.uid,
    this.id,
    this.phoneNumber,
    this.forceResendingToken,
    required this.isLogin,
    this.oldNumberString,
    //  this.onSuccessCallback,
  });
}

class OTPPage extends StatefulWidget {
  final OTPRequest otpRequest;
  const OTPPage({
    Key? key,
    required this.otpRequest,
  }) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  Telephony telephony = Telephony.instance;

  final authBloc = sl<AuthenticationBloc>();
  String _otpString = "";
  OtpFieldController otpBox = OtpFieldController();
  String? verificationId;
  bool isLoading = false;
  bool isResend = true;
  String? sms;
  bool resend = false;
  String? see;

  // timerCheck() {
  //   Future.delayed(const Duration(seconds: 90), () {
  //     setState(() {
  //       resend = true;
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
  }

  void getRemoveFocus(String value, FocusNode focus) {
    if (value.length == 1) {
      focus.requestFocus();
    }
  }

  final PinController = TextEditingController();
  @override
  void initState() {
    super.initState();
    timeCount();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // print(message.address); //+977981******67, sender nubmer
        // print(message.body); //Your OTP code is 34567
        // print(message.date); //1659690242000, timestamp

        String sms = message.body.toString(); //get the message

        if (message.address == "Google" ||
            message.address == "CloudOTP" ||
            message.address == "InfoSMS") {
          //verify SMS is sent for OTP with sender number
          String otpcode = sms.replaceAll(RegExp(r'[^0-9]'), '');
          //prase code from the OTP sms
          // print("This is $otpcode");
          otpBox.set(otpcode.split(""));
          PinController.append(otpcode, 6);
          //split otp code to list of number
          //and populate to otb boxes
          setState(() {});
        } else {
          // print("Normal message.");
        }
      },
      // onBackgroundMessage:(SmsMessage message) {
      //   String sms = message.body.toString();
      //   if(message.address == "Google" || message.address=="CloudOTP" ||
      //       message.address=="wasime" || message.address=="Wasime"){
      //     String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'),'');
      //     otpbox.set(otpcode.split(""));
      //   }} ,
      listenInBackground: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer(
          listener: (conteext, state) async {
            if (state is VerifyOTPFailed) {
              debugPrint(state.errorMessage);
              showSnackbar(
                context: context,
                message: state.errorMessage,
                isSuccessMessage: true,
              );
            }
            if (state is CacheTokenError) {
              showSnackbar(context: context, message: "Error caching token");
            }
            if (state is CacheTokenLoaded) {
              context.pushNamed("signup", queryParameters: {"phoneNumber": ""});
            }
            if (state is VerifyOTPLoaded) {
              if (widget.otpRequest.isLogin) {
                final token =
                    await FirebaseAuth.instance.currentUser?.getIdToken();
                final authorization = {"token": token};
                authBloc.add(
                  CacheTokenEvent(
                    authorization: authorization,
                  ),
                );
              } else {
                if (widget.otpRequest.oldNumberString == null) {
                } else {
                  context.pushNamed("changeNumber",
                      queryParameters: {"phoneNumber": state.user.phoneNumber});
                }
              }
            }
          },
          bloc: authBloc,
          builder: (context, state) {
            if (state is VerifyOTPLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: EdgeInsets.all(
                Sizes().height(
                  context,
                  0.006,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "We've sent a code to the number ${widget.otpRequest.phoneNumber}",
                    ),
                    Space().height(context, 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Pinput(
                          defaultPinTheme: theme(false),
                          focusedPinTheme: theme(false),
                          errorPinTheme: theme(true),
                          controller: PinController,
                          onChanged: onKeyPressed,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          length: 6,
                          onCompleted: (val) async {
                            Future.delayed(const Duration(seconds: 2), () {
                              PhoneAuthCredential params =
                                  PhoneAuthProvider.credential(
                                      verificationId:
                                          widget.otpRequest.verifyId.toString(),
                                      smsCode: _otpString);
                              authBloc.add(
                                VerifyOTPEvent(
                                  params: params,
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    Space().height(context, 0.04),
                    timer(),
                    Space().height(context, 0.04),
                    Row(
                      children: [
                        Visibility(
                          visible: !isResend,
                          child: const Text("Didn't receive OTP?",
                              style: TextStyle(
                                color: Colors.grey,
                              )),
                        ),
                        TextButton(
                            onPressed: () {
                              context.pop("resend");
                            },
                            child: Visibility(
                              visible: !isResend,
                              child: const Text("Resend",
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Row timer() {
    return Row(
      children: [
        Visibility(
          visible: isResend,
          replacement: const Text(
            "Code expired",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          child: Text(
            "This code will expire in 00:${(time).toInt()}",
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
        )
      ],
    );
  }

  PinTheme theme(bool isErrorTheme) {
    return PinTheme(
        width: Sizes().width(context, 0.1),
        margin: EdgeInsets.symmetric(horizontal: Sizes().width(context, 0.02)),
        height: Sizes().height(context, 0.05),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes().height(context, 0.01)),
            border: Border.all(
                color: isErrorTheme
                    ? Colors.red
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.black12
                        : Colors.white)));
  }

  int time = 120;
  void timeCount() {
    Timer.periodic(Duration(seconds: 1), (f) {
      print(f.tick.toString());

      setState(() {
        time--;
      });
      if (time == 0) {
        isResend = !isResend;
        f.cancel();
      }
    });
  }

  void onKeyPressed(String inputValue) {
    setState(() {
      _otpString = inputValue;
    });
  }
}
