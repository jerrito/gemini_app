import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/core/usecase/usecase.dart';
import 'package:gemini/features/authentication/domain/entities/admin.dart';
import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:gemini/features/authentication/domain/usecases/become_a_teacher.dart';
import 'package:gemini/features/authentication/domain/usecases/cache_token.dart';
import 'package:gemini/features/authentication/domain/usecases/delete_account.dart';
import 'package:gemini/features/authentication/domain/usecases/delete_token.dart';
import 'package:gemini/features/authentication/domain/usecases/get_cache_user.dart';
import 'package:gemini/features/authentication/domain/usecases/get_token.dart';
import 'package:gemini/features/authentication/domain/usecases/cache_user.dart';
import 'package:gemini/features/authentication/domain/usecases/get_user.dart';
import 'package:gemini/features/authentication/domain/usecases/log_out.dart';
import 'package:gemini/features/authentication/domain/usecases/refresh_token.dart';
import 'package:gemini/features/authentication/domain/usecases/signin.dart';
import 'package:gemini/features/authentication/domain/usecases/signup.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Signup signup;
  final Signin signin;
  final CacheUserData cacheUserData;
  final GetUserData getUserData;
  final CacheToken cacheToken;
  final GetToken getToken;
  final GetCacheUser getCacheUser;
  final LogOut logout;
  final RefreshToken refreshToken;
  final DeleteAccount deleteAccount;
  final DeleteToken deleteToken;
  final BecomeATeacher becomeATeacher;
  AuthenticationBloc(
      {required this.getCacheUser,
      required this.refreshToken,
      required this.signup,
      required this.signin,
      required this.getUserData,
      required this.deleteToken,
      required this.cacheUserData,
      required this.cacheToken,
      required this.getToken,
      required this.logout,
      required this.deleteAccount,
      required this.becomeATeacher})
      : super(InitState()) {
    //! SIGNUP
    on<SignupEvent>(
      (event, emit) async {
        emit(SignupLoading());
        final response = await signup.call(event.params);

        emit(response.fold(
          (error) {
            return SignupError(errorMessage: error);
          },
          (response) => SignupLoaded(
            response: response,
          ),
        ));
      },
    );

    //! SIGN IN
    on<SigninEvent>(
      (event, emit) async {
        emit(SigninLoading());
        final response = await signin.call(event.params);

        emit(
          response.fold(
            (error) => SigninError(
              errorMessage: error,
            ),
            (response) => SigninLoaded(
              data: response,
            ),
          ),
        );
      },
    );

    //! CACHE DATA
    on<CacheUserDataEvent>((event, emit) async {
      //  emit(CacheUserDataLoading());
      final response = await cacheUserData.call(event.params);

      emit(
        response.fold(
          (l) => CacheUserDataError(errorMessage: l),
          (r) => CacheUserDataLoaded(),
        ),
      );
    });

    // ! GET CACHED DATA
    on<GetUserCacheDataEvent>(
      (event, emit) async {
        //emit(GetUserDataLoading());
        final response = await getCacheUser.getCachedUser();

        emit(
          response.fold(
            (l) => GetUserCacheDataError(errorMessage: l),
            (r) => GetUserCachedDataLoaded(data: r),
          ),
        );
      },
    );

    //! GET USER
    on<GetUserEvent>((event, emit) async {
      emit(GetUserDataLoading());
      final response = await getUserData.call(event.params);
      response.fold(
        (error) => emit(
          GetUserError(errorMessage: error),
        ),
        (response) => emit(
          GetUserLoaded(
            user: response,
          ),
        ),
      );
    });

    //! CACHE TOKEN
    on<CacheTokenEvent>((event, emit) async {
      final response = await cacheToken.call(event.authorization);
      emit(
        response.fold(
          (errorMessage) => CacheTokenError(errorMessage: errorMessage),
          (response) => CacheTokenLoaded(),
        ),
      );
    });

    //!  GET TOKEN
    on<GetTokenEvent>((event, emit) async {
      final response = await getToken.call(NoParams());
      emit(
        response.fold(
          (errorMessage) => GetTokenError(errorMessage: errorMessage),
          (response) => GetTokenLoaded(
            authorization: response,
          ),
        ),
      );
    });

    //! LOG OUT
    on<LogoutEvent>(
      (event, emit) async {
        emit(LogoutLoading());
        final response = await logout.call(event.params);
        emit(response.fold(
          (e) => LogoutError(errorMessage: e),
          (response) => LogoutLoaded(
            successMessage: response,
          ),
        ));
      },
    );

    //! BECOME A TEACHER
    on<BecomeATeacherEvent>(
      (event, emit) async {
        emit(BecomeATeacherLoading());
        final response = await becomeATeacher.call(event.params);
        emit(
          response.fold(
            (e) => BecomeATeacherError(errorMessage: e),
            (response) => BecomeATeacherLoaded(
              adminResponse: response,
            ),
          ),
        );
      },
    );

    //! REFRESH TOKEN
    on<RefreshTokenEvent>(
      (event, emit) async {
        final response = await refreshToken.call(event.refreshToken);
        emit(response.fold(
          (e) => RefreshTokenError(errorMessage: e),
          (response) => RefreshTokenLoaded(
            token: response,
          ),
        ));
      },
    );

    //! DELETE ACCOUNT
    on<DeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      final response = await deleteAccount.call(event.params);
      emit(
        response.fold(
          (e) => DeleteAccountError(errorMessage: e),
          (response) => DeleteAccountLoaded(
            message: response,
          ),
        ),
      );
    });

    //! DELETE Token
    on<DeleteTokenEvent>((event, emit) async {
      emit(DeleteTokenLoading());
      final response = await deleteToken.call(event.params);
      emit(
        response.fold(
          (e) => DeleteTokenError(errorMessage: e),
          (response) => DeleteTokenLoaded(),
        ),
      );
    });
  }
}
