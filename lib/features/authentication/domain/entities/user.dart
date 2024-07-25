// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';

class User extends Equatable {
  final String? userName, email, password,role, profile;
  final bool? isStudent;


  const User({
   required this.isStudent, 
    required this.userName,
    required this.email,
    required this.password,
    required this.profile,
    required this.role,
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
  final SignupResponse data;
  final String token;

 const SigninResponse({required this.data, required this.token});
 
  @override
  List<Object?> get props => [data, token];
}

class SignupResponse extends Equatable {
 
  final User user;
  final String refreshToken;
 
  const SignupResponse({ required this.user, required this.refreshToken});

  

  @override
  List<Object?> get props => [user,refreshToken];

}

