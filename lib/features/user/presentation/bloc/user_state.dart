part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UpdateUserLoaded extends UserState {
  final User user;

  const UpdateUserLoaded({required this.user});
}

class UpdateUserLoading extends UserState {}

class UpdateUserError extends UserState {
  final String errorMessage;
  const UpdateUserError({required this.errorMessage});
}

class UpdateProfileLoaded extends UserState {
  final String profile;

  const UpdateProfileLoaded({required this.profile});
}

class UpdateProfileLoading extends UserState {}

class UpdateProfileError extends UserState {
  final String errorMessage;
  const UpdateProfileError({required this.errorMessage});
}

class PickImageLoaded extends UserState {
  final Uint8List? image;

  const PickImageLoaded({required this.image});
}

class PickImageLoading extends UserState {}

class PickImageError extends UserState {
  final String errorMessage;
  const PickImageError({required this.errorMessage});
}

class ChangePasswordLoaded extends UserState {
  final  String data;
  const ChangePasswordLoaded({required this.data});
}

class ChangePasswordLoading extends UserState {}

class ChangePasswordError extends UserState {
  final String errorMessage;
  const ChangePasswordError({required this.errorMessage});
}
