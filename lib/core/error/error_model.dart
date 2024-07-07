
import 'package:gemini/core/error/errors.dart';

class ErrorModel extends Errors{
  const ErrorModel({required super.errorMessage, required super.error, required super.errorCode});

factory ErrorModel.fromJson(Map<String, dynamic>? json)=>
  ErrorModel(errorMessage: json?["message"],
   error: json?["error"], errorCode: json?["errorCode"],);

  Map<String, dynamic> toMap ()=>
   {
    "message":errorMessage,
    "error":error,
    "errorCode":errorCode
   };
}
