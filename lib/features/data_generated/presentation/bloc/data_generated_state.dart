part of 'data_generated_bloc.dart';

abstract class DataGeneratedState extends Equatable {
  const DataGeneratedState();

  @override
  List<Object> get props => [];
}

class DataGeneratedInitial extends DataGeneratedState {}

final class DataGeneratedLoaded extends DataGeneratedState {
  final Data data;

  const DataGeneratedLoaded({required this.data});
}

final class DataGeneratedLoading extends DataGeneratedState {}

final class DataGeneratedError extends DataGeneratedState {
  final String errorMessage;

  const DataGeneratedError({required this.errorMessage});
}

final class ListDataGeneratedLoaded extends DataGeneratedState {
  final DataInfo listData;

  const ListDataGeneratedLoaded({required this.listData});
}

final class ListDataGeneratedLoading extends DataGeneratedState {}

final class ListDataGeneratedError extends DataGeneratedState {
  final String errorMessage;

  const ListDataGeneratedError({required this.errorMessage});
}

final class DeleteDataGeneratedLoaded extends DataGeneratedState {
  final bool isSuccess;
  const DeleteDataGeneratedLoaded({required this.isSuccess});
}

final class DeleteDataGeneratedLoading extends DataGeneratedState {}

final class DeleteDataGeneratedError extends DataGeneratedState {
  final String errorMessage;
  const DeleteDataGeneratedError({required this.errorMessage});
}

final class GetDataGeneratedLoaded extends DataGeneratedState {
  final Data data;
  const GetDataGeneratedLoaded({required this.data});
}

final class GetDataGeneratedLoading extends DataGeneratedState {}

final class GetDataGeneratedError extends DataGeneratedState {
  final String errorMessage;
  const GetDataGeneratedError({required this.errorMessage});
}

final class DeleteListDataGeneratedLoaded extends DataGeneratedState {
  final bool isSuccess;
  const DeleteListDataGeneratedLoaded({required this.isSuccess});
}

final class DeleteListDataGeneratedLoading extends DataGeneratedState {}

final class DeleteListDataGeneratedError extends DataGeneratedState {
  final String errorMessage;
  const DeleteListDataGeneratedError({required this.errorMessage});
}
