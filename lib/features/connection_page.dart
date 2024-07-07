
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/features/authentication/presentation/provders/token.dart';
import 'package:gemini/locator.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final userBloc = sl<AuthenticationBloc>();
  TokenProvider? tokenProvider;
  String? refreshToken;
  String? token;
  @override
  void initState() {
    super.initState();
    userBloc.add(
      GetTokenEvent(),
    );
  }


  @override
  Widget build(BuildContext context) {
    // context.read<tokenProvider>();
    final tokenProvider=context.read<TokenProvider>();
    return Scaffold(
        body: BlocConsumer(
      bloc: userBloc,
      listener: (context, state) {
        if (state is GetTokenLoaded) {
          refreshToken=state.authorization["refreshToken"];
          // print(refreshToken);
          setState((){});
          userBloc.add(
            RefreshTokenEvent(refreshToken: refreshToken!),
          );
        }
        if(state is RefreshTokenError){
          print("sgs${state.errorMessage}");
          if(state.errorMessage== "No internet connection"){
         context.goNamed("noInternet");   
          }
          else{
         context.goNamed("signin");
          }
          }
        if(state is RefreshTokenLoaded){
          //: TODO use provider to store both tokens
          // token=state.token;
         final tokenGet=state.token;
        
       tokenProvider.setToken=tokenGet;
         token=tokenGet;
         setState((){});
          final Map<String,dynamic> params={
            "token":token,
            "refreshToken":refreshToken
          };
          userBloc.add(
            CacheTokenEvent(authorization: params),
        );
        }
        if(state is CacheTokenLoaded){
          final params={
            "token":token
          };
          userBloc.add(GetUserEvent(params: params,),);
              }
              if(state is CacheTokenError){
                print(state.errorMessage);
           context.goNamed("signin");
                        }
        
        if (state is GetUserLoaded) {
          final user=state.user;

          final Map<String, dynamic> params = {
            "userName": user.userName,
            "email":user.email};
          userBloc.add(CacheUserDataEvent(params: params));
        }
        if (state is CacheUserDataLoaded) {
          context.goNamed("searchPage");
        }
        if(state is GetUserError){
            print(state.errorMessage);
          context.goNamed("signin"); 
        }
        if ( state is GetTokenError) {
          context.goNamed("landing");
        }
        if (state is GetUserCacheDataError) {
          context.goNamed("signin");
        }
      },
      builder: (BuildContext context, Object? state) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
