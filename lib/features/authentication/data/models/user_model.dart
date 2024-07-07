import 'package:gemini/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userName,
    required super.email,
    required super.password,
    required super.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
        userName: json?["userName"],
        email: json?["email"],
        password: json?["password"],
        profile: json?["profile"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "user_name": userName,
        "email": email,
        "password": password,
        "profile": profile,
      };
}

class SigninResponseModel extends SigninResponse {
  const SigninResponseModel({required super.user, required super.refreshToken, required super.token});

  factory SigninResponseModel.fromJson(Map<String, dynamic> json) =>
      SigninResponseModel(user: UserModel.fromJson(json["user"]),
        token:json["token"],
        refreshToken: json["refreshToken"]);
}


class SignupResponseModel extends SignupResponse{
 const SignupResponseModel({required super.user, required super.refreshToken});

 factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
 SignupResponseModel(user: UserModel.fromJson(json["user"]),
  refreshToken: json["refreshToken"]);

}