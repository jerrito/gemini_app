import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'learning_event.dart';
part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  LearningBloc() : super(LearningInitial()) {
    on<LearningEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
