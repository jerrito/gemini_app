part of 'learning_bloc.dart';

abstract class LearningState extends Equatable {
  const LearningState();  

  @override
  List<Object> get props => [];
}
class LearningInitial extends LearningState {}
