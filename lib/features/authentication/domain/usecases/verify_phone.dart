import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';

class VerifyPhoneNumber {
  final AuthenticationRepository repository;

  VerifyPhoneNumber({required  this.repository});

  Future<void> verifyPhoneNumber(String phoneNumber,
      Function(String verificationId, int? resendToken) onCodeSent,
      Function(PhoneAuthCredential phoneAuthCredential) onCompleted,
      Function(FirebaseAuthException) onFailed) async {
    await repository.verifyPhoneNumber(
      phoneNumber,
      onCodeSent,
      onCompleted,
      onFailed,
    );
  }
}