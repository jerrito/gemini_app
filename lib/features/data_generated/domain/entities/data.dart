import 'package:equatable/equatable.dart';

class Data extends Equatable {
  final String? data, title;
  final bool? hasImage;
  final dynamic dataImage;
  final int dateTime;

  const Data(
      {required this.dateTime,
      required this.hasImage,
      required this.data,
      required this.title,
      required this.dataImage});
  @override
  List<Object?> get props => [
        data,
        title,
        dateTime,
        hasImage,
        dataImage,
      ];
}

class DataIds extends Equatable {
  final List<String> ids;

  const DataIds({required this.ids});

  @override
  List<Object?> get props => [ids];
}
