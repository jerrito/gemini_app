import 'package:gemini/features/data_generated/domain/entities/data.dart';

class DataModel extends Data {
  const DataModel({
    required super.data,
    required super.title,
    required super.dataImage,
    required super.hasImage,
    required super.dateTime,
  });

  factory DataModel.fromJson(Map<String, dynamic>? json) => DataModel(
        data: json?["data"],
        title: json?["title"],
        dataImage: json?["dataImage"],
        hasImage: json?["hasImage"],
        dateTime: json?["dateTime"],
      );
}

class DataIdsModel extends DataIds {
  const DataIdsModel({required super.ids});

  
}
