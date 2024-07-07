
import 'package:gemini/features/authentication/domain/entities/authorization.dart';

class AuthorizationModel extends Authorization{
 const AuthorizationModel({required super.accessToken, required super.refreshToken});

 factory AuthorizationModel.fromJson(Map<String, dynamic> json)=>
 AuthorizationModel(
           accessToken: json["token"],
             refreshToken: json["refreshToken"],);
}