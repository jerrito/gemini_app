part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends UserEvent {
  final Map<String, dynamic> params;

  const UpdateUserEvent({required this.params});
}

class UpdateProfileEvent extends UserEvent {
  final Map<String, dynamic> params;

  const UpdateProfileEvent({required this.params});
}

class PickImageEvent extends UserEvent {
  final Map<String, dynamic> params;

  const PickImageEvent({required this.params});
}



class ChangePasswordEvent extends UserEvent{
final  Map<String, dynamic> params;

 const  ChangePasswordEvent({required this.params});
}

