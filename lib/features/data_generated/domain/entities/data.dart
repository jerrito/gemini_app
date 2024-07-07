import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class Data extends Equatable{
  final String? data, title ;
  final bool? hasImage;
  final int userId, id;
  final Uint8List? dataImage;

 const Data({  required this.hasImage, required this.userId,required this.id, required this.data, required this.title, required this.dataImage}); 
  @override
  List<Object?> get props => [data,  title, userId, id, hasImage, dataImage];

}