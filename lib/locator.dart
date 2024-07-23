import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:gemini/core/network/networkinfo.dart';
import 'package:gemini/features/authentication/data/data_source/local_ds.dart';
import 'package:gemini/features/authentication/data/data_source/remote_ds.dart';
import 'package:gemini/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:gemini/features/authentication/domain/repository/auth_repo.dart';
import 'package:gemini/features/authentication/domain/usecases/cache_token.dart';
import 'package:gemini/features/authentication/domain/usecases/cache_user.dart';
import 'package:gemini/features/user/domain/usecases/change_password.dart';
import 'package:gemini/features/authentication/domain/usecases/get_cache_user.dart';
import 'package:gemini/features/authentication/domain/usecases/get_token.dart';
import 'package:gemini/features/authentication/domain/usecases/get_user.dart';
import 'package:gemini/features/authentication/domain/usecases/log_out.dart';
import 'package:gemini/features/authentication/domain/usecases/refresh_token.dart';
import 'package:gemini/features/authentication/domain/usecases/signin.dart';
import 'package:gemini/features/authentication/domain/usecases/signup.dart';
import 'package:gemini/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:gemini/features/data_generated/data/datasources/remote_ds.dart';
import 'package:gemini/features/data_generated/data/repositories/data_generated_repo_impl.dart';
import 'package:gemini/features/data_generated/domain/repositories/data_generated_repo.dart';
import 'package:gemini/features/data_generated/domain/usecases/delete_data_generated.dart';
import 'package:gemini/features/data_generated/domain/usecases/delete_multiple_data.dart';
import 'package:gemini/features/data_generated/domain/usecases/get_data_generated_by_d.dart';
import 'package:gemini/features/data_generated/domain/usecases/list_data_generated.dart';
import 'package:gemini/features/data_generated/presentation/bloc/data_generated_bloc.dart';
import 'package:gemini/features/search_text/data/datasource/local_ds.dart';
import 'package:gemini/features/search_text/data/datasource/remote_ds.dart';
import 'package:gemini/features/search_text/data/repository/repository_impl.dart';
import 'package:gemini/features/search_text/domain/repository/search_repository.dart';
import 'package:gemini/features/data_generated/domain/usecases/add_data_generated.dart';
import 'package:gemini/features/search_text/domain/usecase/add_multi_images.dart';
import 'package:gemini/features/search_text/domain/usecase/chat.dart';
import 'package:gemini/features/search_text/domain/usecase/delete_all_data.dart';
import 'package:gemini/features/search_text/domain/usecase/generate_content.dart';
import 'package:gemini/features/search_text/domain/usecase/read_sql_data.dart';
import 'package:gemini/features/search_text/domain/usecase/search_text.dart';
import 'package:gemini/features/search_text/domain/usecase/search_text_image.dart';
import 'package:gemini/features/search_text/presentation/bloc/search_bloc.dart';
import 'package:gemini/features/user/data/datasources/local_ds.dart';
import 'package:gemini/features/user/data/datasources/remote.dart';
import 'package:gemini/features/user/data/repositories/user_repo_impl.dart';
import 'package:gemini/features/user/domain/repositories/user_repository.dart';
import 'package:gemini/features/user/domain/usecases/add_image.dart';
import 'package:gemini/features/user/domain/usecases/update_profile.dart';
import 'package:gemini/features/user/domain/usecases/update_user.dart';
import 'package:gemini/features/user/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void initDependencies() async {
  //auth
  initAuthentication();

  //search
  initSearch();

  // data generated
  dataGenerated();

// user
  user();
  //! External

  //http
  sl.registerLazySingleton(() => http.Client());

  //network
  sl.registerLazySingleton(
    () => NetworkInfoImpl(
      dataConnectionChecker: sl(),
    ),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: sl(),
    ),
  );

  //data connection
  sl.registerLazySingleton(
    () => DataConnectionChecker(),
  );

  //shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}

void user() {
// bloc
  sl.registerFactory(
    () => UserBloc(
      updateUser: sl(),
      updateProfile: sl(),
      changePassword: sl(),
      pickImage: sl(),
    ),
  );

// usecases

sl.registerLazySingleton(
    () => ChangePassword(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateUser(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => PickImage(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateProfile(
      repository: sl(),
    ),
  );

//repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
      localDatasource: sl(),
    ),
  );

// data source

  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(),
  );

  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(
      client: sl(),
    ),
  );
}

void dataGenerated() {
  //bloc
  sl.registerFactory(
    () => DataGeneratedBloc(
        addDataGenerated: sl(),
        listDataGenerated: sl(),
        deleteDataGenerated: sl(),
        getDataGenerated: sl(),
        deleteListDataGenerated: sl()),
  );

  //usecases

  sl.registerLazySingleton(
    () => DeleteListDataGenerated(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDataGeneratedById(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteDataGenerated(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ListDataGenerated(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => AddDataGenerated(
      repository: sl(),
    ),
  );

  //repo
  sl.registerLazySingleton<DataGeneratedRepository>(
    () => DataGeneratedRepositorympl(
      networkInfo: sl(),
      dataGeneratedRemoteDatasource: sl(),
    ),
  );

  //datasource

  sl.registerLazySingleton<DataGeneratedRemoteDatasource>(
    () => DataGeneratedRemoteDatasourceImpl(
      client: http.Client(),
    ),
  );
}

void initSearch() {
  //bloc
  sl.registerFactory(
    () => SearchBloc(
        searchText: sl(),
        searchTextAndImage: sl(),
        addMultipleImage: sl(),
        generateContent: sl(),
        chat: sl(),
        readSQLData: sl(),
        networkInfo: sl(),
        deleteAllData: sl(),
        ),
  );

  sl.registerLazySingleton(
    () => DataGeneratedRemoteDatasourceImpl(client: sl()),
  );

  sl.registerLazySingleton(
    () => SearchRemoteDatasourceImpl(),
  );

  //usecases
  sl.registerLazySingleton(() => DeleteAllData(searchRepository: sl()));

  sl.registerLazySingleton(
    () => ReadData(
      searchRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SearchText(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => Chat(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GenerateContent(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => SearchTextAndImage(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AddMultipleImages(
      repository: sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      networkInfo: sl(),
      searchRemoteDatasource: sl(),
      searchLocalDatasource: sl(),
    ),
  );

  //data source

  sl.registerLazySingleton<SearchRemoteDatasource>(
    () => SearchRemoteDatasourceImpl(),
  );

  sl.registerLazySingleton<SearchLocalDatasource>(
    () => SearchLocalDatasourceImpl(),
  );

  // sl.registerLazySingleton<NetworkInfo>(
  //   () => NetworkInfoImpl(
  //     dataConnectionChecker: sl(),
  //   ),
  // );

  // sl.registerLazySingleton(
  //   () => DataConnectionChecker(),
  // );
}

void initAuthentication() {
  //bloc

  sl.registerFactory(
    () => AuthenticationBloc(
        signin: sl(),
        signup: sl(),
        getUserData: sl(),
        cacheUserData: sl(),
        cacheToken: sl(),
        getToken: sl(),
        getCacheUser: sl(),
        logout: sl(),
        refreshToken: sl(),
),
  );

  //usecases
  

  sl.registerLazySingleton(
    () => RefreshToken(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LogOut(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetCacheUser(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CacheToken(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetToken(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CacheUserData(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetUserData(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => Signin(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => Signup(
      repository: sl(),
    ),
  );

  //repository

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      userLocalDatasource: sl(),
      userRemoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  // datasources
  sl.registerLazySingleton<AuthenticationRemoteDatasource>(
    () => AuthenticationRemoteDatasourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<AuthenticationLocalDatasource>(
    () => AuthenticationLocalDatasourceImpl(),
  );
}
