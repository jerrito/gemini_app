import 'package:equatable/equatable.dart';

class Authorization extends Equatable{
  final String accessToken;
  final String refreshToken;

 const Authorization({required this.accessToken, required this.refreshToken});

 toMap()=>
 {
  "token":accessToken,
  "refreshToken":refreshToken
 }; 
  
  @override
  List<Object?> get props =>[accessToken, refreshToken];
}