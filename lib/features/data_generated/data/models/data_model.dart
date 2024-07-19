import 'package:gemini/features/data_generated/domain/entities/data.dart';

class DataModel extends Data {
  const DataModel({
    required super.userId,
    required super.id,
    required super.data,
    required super.title,
    required super.dataImage,
    required super.hasImage,
    required super.dateTime,
    required super.imageUrl,
  });

  factory DataModel.fromJson(Map<String, dynamic>? json) => DataModel(
        userId: json?["userId"],
        id: json?["id"],
        data: json?["data"],
        title: json?["title"],
        dataImage: json?["dataImage"],
        hasImage: json?["hasImage"],
        imageUrl: json?["imageUrl"],
        dateTime: DateTime.parse(json?["dateTime"]),
      );
}

