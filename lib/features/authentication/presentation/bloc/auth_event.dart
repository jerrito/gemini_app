part of 'auth_bloc.dart';

sealed class AuthenticationEvent {}

class SignupEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;
  SignupEvent({required this.params});
}

class SigninEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;
  SigninEvent({required this.params});
}


class CreateUserWithEmailAndPasswordEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;
  CreateUserWithEmailAndPasswordEvent({required this.params});
}

class CacheUserDataEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  CacheUserDataEvent({required this.params});
}

class GetUserCacheDataEvent extends AuthenticationEvent {
  GetUserCacheDataEvent();
}

class CacheTokenEvent extends AuthenticationEvent {
  final Map<String,dynamic>  authorization;
  CacheTokenEvent({required this.authorization});
}

class GetTokenEvent extends AuthenticationEvent {
  GetTokenEvent();
}

class GetUserEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  GetUserEvent({required this.params});
}


class LogoutEvent extends AuthenticationEvent{
final  Map<String, dynamic> params;

  LogoutEvent({required this.params});
}

class RefreshTokenEvent extends AuthenticationEvent{
  final  String refreshToken;

  RefreshTokenEvent({required this.refreshToken});

}