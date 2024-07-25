import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  TeacherBloc() : super(TeacherInitial()) {
    on<TeacherEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
