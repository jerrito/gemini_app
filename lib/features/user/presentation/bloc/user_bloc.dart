import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/user/domain/usecases/add_image.dart';
import 'package:gemini/features/user/domain/usecases/update_profile.dart';
import 'package:gemini/features/user/domain/usecases/update_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final PickImage pickImage;
  final UpdateUser updateUser;
  final UpdateProfile updateProfile;
  UserBloc({
    required this.pickImage,
    required this.updateProfile,
    required this.updateUser,
  }) : super(UserInitial()) {
    on<UserEvent>((event, emit) {
      // TODO: implement event handler
    });

    //! UPDATE USER
    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateUserLoading());
      final response = await updateUser.call(event.params);

      emit(
        response.fold(
          (error) => UpdateUserError(errorMessage: error),
          (response) => UpdateUserLoaded(user: response),
        ),
      );
    });

    //! UPDATE PROFILE
    on<UpdateProfileEvent>((event, emit) async {
      emit(UpdateProfileLoading());

      final response = await updateProfile.call(event.params);

      emit(
        response.fold(
          (error) => UpdateProfileError(
            errorMessage: error,
          ),
          (response) => UpdateProfileLoaded(
            profile: response,
          ),
        ),
      );
    });

    //! Pick IMAGE
    on<PickImageEvent>((event, emit) async {
      emit(PickImageLoading());
      final response = await pickImage.call(event.params);
      emit(
        response.fold(
          (error) => PickImageError(errorMessage: error),
          (response) => PickImageLoaded(
            image: response,
          ),
        ),
      );
    });
  }
}
