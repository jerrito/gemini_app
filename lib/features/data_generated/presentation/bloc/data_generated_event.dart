part of 'data_generated_bloc.dart';

abstract class DataGeneratedEvent extends Equatable {
  const DataGeneratedEvent();

  @override
  List<Object> get props => [];
}

final class DataEvent extends DataGeneratedEvent {
  final Map<String, dynamic> params;
  const DataEvent({required this.params});
}

final class ListDataGeneratedEvent extends DataGeneratedEvent {
  final Map<String, dynamic> params;
  const ListDataGeneratedEvent({required this.params});
}

final class DeleteDataGeneratedEvent extends DataGeneratedEvent {
  final Map<String, dynamic> params;
  const DeleteDataGeneratedEvent({required this.params});
}

final class DeleteListDataGeneratedEvent extends DataGeneratedEvent {
  final Map<String, dynamic> params;
  const DeleteListDataGeneratedEvent({required this.params});
}

final class GetDataGeneratedEvent extends DataGeneratedEvent {
  final Map<String, dynamic> params;
  const GetDataGeneratedEvent({required this.params});
}
