import 'package:gemini/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userName,
    required super.email,
    required super.password,
    required super.profile,
    required super.emailVerified,
    required super.disabled,
    required super.metaData,
    required super.phoneNumber,
    required super.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
        userName: json?["displayName"],
        email: json?["email"],
        password: json?["password"],
        profile: json?["photoURL"],
        uid: json?["uid"],
        phoneNumber: json?["phoneNumber"],
        emailVerified: json?["emailVerified"],
        disabled: json?["disabled"],
        metaData: MetaDataModel.fromJson(
          json?["metaData"],
        ),
      );

  // @override
  // Map<String, dynamic> toMap() => {
  //       "user_name": userName,
  //       "email": email,
  //       "password": password,
  //       "profile": profile,
  //       "isStudent": emailVerified,
  //       "role": role,
  //     };
}

class MetaDataModel extends MetaData {
  const MetaDataModel({
    required super.lastSignInTime,
    required super.creationTime,
    required super.lastRefreshTime,
  });

  factory MetaDataModel.fromJson(Map<String, dynamic>? json) => MetaDataModel(
        lastSignInTime: json?["lastSignInTime"],
        creationTime: json?["creationTime"],
        lastRefreshTime: json?["lastRefreshTime"],
      );
}
// class SigninResponseModel extends SigninResponse {
//   const SigninResponseModel({required super.data, required super.token});

//   factory SigninResponseModel.fromJson(Map<String, dynamic> json) =>
//       SigninResponseModel(
//         data: SignupResponseModel.fromJson(json["user"]),
//         token: json["token"],
//       );
// }

// class SignupResponseModel extends SignupResponse {
//   const SignupResponseModel(
//       {required super.user, required super.refreshToken});

//   factory SignupResponseModel.fromJson(Map<String, dynamic>? json) =>
//       SignupResponseModel(
//         user: UserModel.fromJson(json?["user"]),
//         refreshToken: json?["refreshToken"]);
// }
