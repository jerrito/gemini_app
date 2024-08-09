import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemini/features/data_generated/domain/entities/data.dart';
import 'package:gemini/features/data_generated/domain/entities/data_info.dart';
import 'package:gemini/features/data_generated/domain/usecases/add_data_generated.dart';
import 'package:gemini/features/data_generated/domain/usecases/delete_data_generated.dart';
import 'package:gemini/features/data_generated/domain/usecases/delete_multiple_data.dart';
import 'package:gemini/features/data_generated/domain/usecases/get_data_generated_by_d.dart';
import 'package:gemini/features/data_generated/domain/usecases/list_data_generated.dart';

part 'data_generated_event.dart';
part 'data_generated_state.dart';

class DataGeneratedBloc extends Bloc<DataGeneratedEvent, DataGeneratedState> {
  final AddDataGenerated addDataGenerated;
  final ListDataGenerated listDataGenerated;
  final DeleteDataGenerated deleteDataGenerated;
  final DeleteListDataGenerated deleteListDataGenerated;
  final GetDataGeneratedById getDataGenerated;

  DataGeneratedBloc({
    required this.addDataGenerated,
    required this.listDataGenerated,
    required this.deleteDataGenerated,
    required this.getDataGenerated,
    required this.deleteListDataGenerated,
  }) : super(DataGeneratedInitial()) {
    on<DataEvent>((event, emit) async {
      emit(DataGeneratedLoading());
      final response = await addDataGenerated.call(event.params);
      emit(
        response.fold(
          (error) => DataGeneratedError(
            errorMessage: error,
          ),
          (response) => DataGeneratedLoaded(
            data: response,
          ),
        ),
      );
    });

    on<ListDataGeneratedEvent>((event, emit) async {
      emit(ListDataGeneratedLoading());
      final response = await listDataGenerated.call(event.params);

      emit(
        response.fold(
          (error) => ListDataGeneratedError(
            errorMessage: error,
          ),
          (response) => ListDataGeneratedLoaded(
            listData: response,
          ),
        ),
      );
    });
    on<DeleteDataGeneratedEvent>((event, emit) async {
      emit(DeleteDataGeneratedLoading());
      final response = await deleteDataGenerated.call(event.params);
      emit(
        response.fold(
          (error) => DeleteDataGeneratedError(
            errorMessage: error,
          ),
          (response) => DeleteDataGeneratedLoaded(
            isSuccess: response,
          ),
        ),
      );
    });

    on<DeleteListDataGeneratedEvent>((event, emit) async {
      emit(DeleteListDataGeneratedLoading());
      final response = await deleteListDataGenerated.call(event.params);
      emit(
        response.fold(
          (error) => DeleteListDataGeneratedError(
            errorMessage: error,
          ),
          (response) => DeleteListDataGeneratedLoaded(
            isSuccess: response,
          ),
        ),
      );
    });

    on<GetDataGeneratedEvent>((event, emit) async {
      emit(GetDataGeneratedLoading());
      final response = await getDataGenerated.call(event.params);

      emit(
        response.fold(
          (error) => GetDataGeneratedError(
            errorMessage: error,
          ),
          (response) => GetDataGeneratedLoaded(
            data: response,
          ),
        ),
      );
    });
  }
}
