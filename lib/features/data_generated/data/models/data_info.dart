import 'package:gemini/features/data_generated/data/models/data_model.dart';
import 'package:gemini/features/data_generated/domain/entities/data_info.dart';

class DataInfoModel extends DataInfo {
  const DataInfoModel({
    required super.data,
    required super.dataIds,
  });

  factory DataInfoModel.fromJson(Map<String, dynamic>? json) => DataInfoModel(
        data: List<DataModel>.from(
          json?["list"].map(
            (e) => DataModel.fromJson(e),
          ),
        ),
        dataIds: List<String>.from(json?["ids"].map((e) => e)),
      );
}
