import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userName, email, password, profile;

  const User({
    required this.userName,
    required this.email,
    required this.password,
    required this.profile,
  });

  @override
  List<Object?> get props => [
        userName,
        email,
        password,
        profile,
      ];
  Map<String, dynamic> toMap() => {
        "userName": userName,
        "email": email,
        "password": password,
        "profile": profile,
      };
}



class SigninResponse extends Equatable {
  final User user;
  final String refreshToken, token;

 const SigninResponse({required this.user, required this.token, required this.refreshToken});
 
  @override
  List<Object?> get props => [user, token, refreshToken];
}

class SignupResponse extends Equatable {

  final User user;
  final String refreshToken;

  const SignupResponse({required this.user, required this.refreshToken});

  

  @override
  List<Object?> get props => throw UnimplementedError();

}

