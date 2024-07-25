part of 'auth_bloc.dart';

abstract class AuthenticationState {}

class InitState extends AuthenticationState {}

class SignupLoaded extends AuthenticationState {
  final SignupResponse response;

  SignupLoaded({required this.response});
}

class SignupLoading extends AuthenticationState {}

class SignupError extends AuthenticationState {
  final String errorMessage;
  SignupError({required this.errorMessage});
}

class SigninLoaded extends AuthenticationState {
  final SigninResponse data;

  SigninLoaded({required this.data});
}

class SigninLoading extends AuthenticationState {}

class SigninError extends AuthenticationState {
  final String errorMessage;
  SigninError({required this.errorMessage});
}

class CacheUserDataLoaded extends AuthenticationState {
  CacheUserDataLoaded();
}

class CacheUserDataError extends AuthenticationState {
  final String errorMessage;
  CacheUserDataError({required this.errorMessage});
}

class GetUserCachedDataLoaded extends AuthenticationState {
  final Map<String, dynamic> data;
  GetUserCachedDataLoaded({required this.data});
}

class GetUserDataLoading extends AuthenticationState {}

class GetUserCacheDataError extends AuthenticationState {
  final String errorMessage;
  GetUserCacheDataError({required this.errorMessage});
}

class CacheTokenLoaded extends AuthenticationState {}

class CacheTokenError extends AuthenticationState {
  final String errorMessage;

  CacheTokenError({required this.errorMessage});
}

class GetTokenLoaded extends AuthenticationState {
  final Map<String, dynamic> authorization;
  GetTokenLoaded({required this.authorization});
}

class GetTokenError extends AuthenticationState {
  final String errorMessage;
  GetTokenError({required this.errorMessage});
}

class GetUserLoaded extends AuthenticationState {
  final User user;

  GetUserLoaded({required this.user});
}

class GetUserLoading extends AuthenticationState {}

class GetUserError extends AuthenticationState {
  final String errorMessage;
  GetUserError({required this.errorMessage});
}

class LogoutLoaded extends AuthenticationState {
  final String successMessage;
  LogoutLoaded({required this.successMessage});
}

class LogoutLoading extends AuthenticationState {}

class LogoutError extends AuthenticationState {
  final String errorMessage;
  LogoutError({required this.errorMessage});
}

class RefreshTokenLoaded extends AuthenticationState {
  final String token;
  RefreshTokenLoaded({required this.token});
}

class RefreshTokenLoading extends AuthenticationState {}

class RefreshTokenError extends AuthenticationState {
  final String errorMessage;
  RefreshTokenError({required this.errorMessage});
}

class DeleteAccountLoaded extends AuthenticationState {
  final String message;
  DeleteAccountLoaded({required this.message});
}

class DeleteAccountLoading extends AuthenticationState {}

class DeleteAccountError extends AuthenticationState {
  final String errorMessage;
  DeleteAccountError({required this.errorMessage});
}



class DeleteTokenLoaded extends AuthenticationState {
  DeleteTokenLoaded();
}

class DeleteTokenLoading extends AuthenticationState {}

class DeleteTokenError extends AuthenticationState {
  final String errorMessage;
  DeleteTokenError({required this.errorMessage});
}


class BecomeATeacherLoaded extends AuthenticationState {
 final AdminResponse adminResponse;
  BecomeATeacherLoaded({required this.adminResponse});
}

class BecomeATeacherLoading extends AuthenticationState {}

class BecomeATeacherError extends AuthenticationState {
  final String errorMessage;
  BecomeATeacherError({required this.errorMessage});
}
