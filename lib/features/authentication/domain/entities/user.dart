// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userName, email, password, uid, profile, phoneNumber;
  final bool? emailVerified, disabled;
  final MetaData? metaData;

  const User(
      {required this.emailVerified,
      required this.userName,
      required this.email,
      required this.password,
      required this.profile,
      required this.disabled,
      required this.phoneNumber,
      required this.metaData,
      required this.uid});

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

class MetaData extends Equatable {
  final String? lastSignInTime, creationTime, lastRefreshTime;

  const MetaData({
    required this.lastSignInTime,
    required this.creationTime,
    required this.lastRefreshTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        lastRefreshTime,
        creationTime,
        lastSignInTime,
      ];
}


// SigninResponse extends Equatable {
//   final SignupResponse data;
//   final String token;

//  const SigninResponse({required this.data, required this.token});
 
//   @override
//   List<Object?> get props => [data, token];
// }

// class SignupResponse extends Equatable {
 
//   final User user;
//   final String refreshToken;
 
//   const SignupResponse({ required this.user, required this.refreshToken});

  

//   @override
//   List<Object?> get props => [user,refreshToken];

// }

