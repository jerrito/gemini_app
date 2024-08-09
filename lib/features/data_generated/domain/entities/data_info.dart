import 'package:equatable/equatable.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';

class DataInfo extends Equatable {
  final List<Data> data;
  final List<String> dataIds;

  const DataInfo({
    required this.data,
    required this.dataIds,
  });
  @override
  List<Object?> get props => [
        data,
        dataIds,
      ];
}
