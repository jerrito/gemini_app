import 'package:equatable/equatable.dart';

class Errors extends Equatable{
 final String? errorMessage, error;
 final String? errorCode;

  const Errors({required this.errorMessage, required this.error, required this.errorCode});
 
  
  @override
  List<Object?> get props => [errorMessage, error, errorCode,];
}