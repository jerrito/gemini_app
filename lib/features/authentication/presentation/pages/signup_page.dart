import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/size/sizes.dart';
import 'package:gemini/core/spacing/whitspacing.dart';
import 'package:gemini/core/strngs.dart';
import 'package:gemini/core/widgets/default_button.dart';
import 'package:gemini/core/widgets/default_textfield.dart';
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
  final userBloc = sl<AuthenticationBloc>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
   String? refreshToken ;
   GlobalKey<FormState> formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Signup")),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizes().height(context, 0.01),
              vertical: Sizes().height(context, 0.02)),
          child: BlocConsumer(
            bloc: userBloc,
            listener: (context, state) {
              if (state is SignupError) {
                if (!context.mounted) return;
                showSnackbar(context:context,message: state.errorMessage);
              }

              if (state is CacheUserDataError) {
                if (!context.mounted) return;
                showSnackbar(context:context,message: state.errorMessage);
              }
              if(state is CacheTokenLoaded){

                context.goNamed("searchPage");
              }
              if(state is CacheTokenError){
                if (!context.mounted) return;
                showSnackbar(context:context,message: state.errorMessage);
              }
                            if (state is CacheUserDataLoaded) {
                final authorization={
                  "refreshToken":refreshToken,
                  "token":null
                };
                userBloc.add(CacheTokenEvent(
                  authorization:
                    authorization,),);
              }
              if (state is SignupLoaded) {
                final data=state.response.user;
                final refreshTokenResponse=state.response.refreshToken;
                 refreshToken=refreshTokenResponse;
                 setState((){});  
                final params= {
                      "userName": data.userName,
                      "email": data.email,
                      "profile": data.profile
                    };
                userBloc.add(
                  CacheUserDataEvent(
                    params:params,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SignupLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return DefaultButton(
                  onTap:(){
                     if(formKey.currentState?.validate() == true )
                    {
                    final Map<String, dynamic> params = {
                       "userName": nameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                    };
                    userBloc.add(
                        SignupEvent(params: params));
                  }},
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
                      validator: (value){
                           if (value?.isEmpty ?? true) {
                                          return fieldRequired;
                                        }
                        
                                        if (!isLength(value!, 2)) {
                                          return mustBePasswordCharacters;
                                        }
                                  
                          return null;
                        },
                      builder:(field)=> DefaultTextForm(
                        errorText: field.errorText,
                         onChanged: (value)=>field.didChange(value),
                        controller: nameController,
                        hintText: "Enter Username",
                        label: "UserName",
                      ),
                    ),
                    Space().height(context, 0.02),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value){
                           if (value?.isEmpty ?? true) {
                                          return fieldRequired;
                                        }
                        
                                        if (!isEmail(value!, )) {
                                          return mustBeEmail;
                                        }
                                        
                                  
                          return null;
                        },
                      builder:(field)=> DefaultTextForm(
                        errorText: field.errorText,
                        textInputType: TextInputType.emailAddress,
                         onChanged: (value)=>field.didChange(value),
                        controller: emailController,
                        hintText: "Enter Email",
                        label: "Email",
                      ),
                    ),
                    Space().height(context, 0.02),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value){
                           if (value?.isEmpty ?? true) {
                                          return fieldRequired;
                                        }
                        
                                        if (!isLength(value!, 6)) {
                                          return mustBePasswordCharacters;
                                        }
                                        
                                  
                          return null;
                        },
                      builder:(field)=> DefaultTextForm(
                        errorText: field.errorText,
                         onChanged: (value)=>field.didChange(value),
                        obscureText:obscureText ,
                        suffixIcon:suffixIcon() ,
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
                     
  bool  obscureText= false;
  Widget suffixIcon()
{
  return Visibility(
    visible: obscureText,
    replacement: const Icon(Icons.close) ,
    child: const Icon(Icons.remove_red_eye));
}}
