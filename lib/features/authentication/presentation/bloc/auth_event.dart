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

final class PhoneNumberEvent extends AuthenticationEvent {
  final String phoneNumber;

  PhoneNumberEvent({required this.phoneNumber});
}

final class PhoneNumberErrorEvent extends AuthenticationEvent {
  final String error;
  PhoneNumberErrorEvent({required this.error});
}

final class PhoneNumberLoginEvent extends AuthenticationEvent {
  final String phoneNumber;
  PhoneNumberLoginEvent({required this.phoneNumber});
}

class CheckPhoneNumberEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;
  CheckPhoneNumberEvent({required this.params});
}

final class CodeSentEvent extends AuthenticationEvent {
  final String verificationId;
  final int forceResendingToken;

  CodeSentEvent({
    required this.forceResendingToken,
    required this.verificationId,
  });
}

final class VerificationCompleteEvent extends AuthenticationEvent {
  final auth.PhoneAuthCredential phoneAuthCredential;
  VerificationCompleteEvent({required this.phoneAuthCredential});
}

final class VerifyOTPEvent extends AuthenticationEvent {
  final auth.PhoneAuthCredential params;

  VerifyOTPEvent({required this.params});
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
  final Map<String, dynamic> authorization;
  CacheTokenEvent({required this.authorization});
}

class GetTokenEvent extends AuthenticationEvent {
  GetTokenEvent();
}

class GetUserEvent extends AuthenticationEvent {
  final Map<String, dynamic>? params;

  GetUserEvent({ this.params});
}

class LogoutEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  LogoutEvent({required this.params});
}

class RefreshTokenEvent extends AuthenticationEvent {
  final String refreshToken;

  RefreshTokenEvent({required this.refreshToken});
}

class DeleteAccountEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  DeleteAccountEvent({required this.params});
}

class DeleteTokenEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  DeleteTokenEvent({required this.params});
}

class BecomeATeacherEvent extends AuthenticationEvent {
  final Map<String, dynamic> params;

  BecomeATeacherEvent({required this.params});
}
