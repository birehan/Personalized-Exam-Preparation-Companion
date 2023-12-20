import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_user_avatar_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_top_users_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_password_usercase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_username_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';

import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'features/profile/presentation/bloc/logout/logout_bloc.dart';

import 'core/core.dart';
import 'features/features.dart';
import 'features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features
  //! Feature_#1 Authentication ----------------------------

  // Bloc
  serviceLocator.registerFactory(
    () => AuthenticationBloc(
      signupUsecase: serviceLocator(),
      loginUsecase: serviceLocator(),
      logoutUsecase: serviceLocator(),
      forgetPasswordUsecase: serviceLocator(),
      changePasswordUsecase: serviceLocator(),
      initializeAppUsecase: serviceLocator(),
      getAppInitializationUsecase: serviceLocator(),
      resendOtpVerificationUsecase: serviceLocator(),
      sendOtpVerificationUsecase: serviceLocator(),
      signInWithGoogleUsecase: serviceLocator(),
      signOutWithGoogleUsecase: serviceLocator(),
      getSignInWithGoogleUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SignupFormBloc(),
  );
  serviceLocator.registerFactory(
    () => ChangePasswordFormBloc(),
  );
  serviceLocator.registerFactory(
    () => GetUserBloc(
      getUserCredentialUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator
      .registerLazySingleton(() => SignupUsecase(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoginUsecase(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LogoutUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ForgetPasswordUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ChangePasswordUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SendOtpVerificationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ResendOtpVerificationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => InitializeAppUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAppInitializationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetUserCredentialUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SignInWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SignOutWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetSignInWithGoogleUsecase(repository: serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDatasource: serviceLocator(),
      localDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // DataSource
  serviceLocator.registerLazySingleton<AuthenticationLocalDatasource>(
    () => AuthenticationLocalDatasourceImpl(
      flutterSecureStorage: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthenticationRemoteDatasource>(
    () => AuthenticationRemoteDatasourceImpl(
      client: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      flutterSecureStorage: serviceLocator(),
      client: serviceLocator(),
    ),
  );

  //! Feature 10 Proifle
  serviceLocator.registerFactory(
    () => LogoutBloc(
      logoutUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UsersLeaderboardBloc(getTopUsersUsecase: serviceLocator()),
  );
  // Usecase
  serviceLocator.registerLazySingleton(
    () => ProfileLogoutUsecase(profileRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetTopUsersUsecase(profileRepositories: serviceLocator()),
  );
  // Repository
  serviceLocator.registerLazySingleton<ProfileRepositories>(
    () => ProfileRepositoryImpl(
      profileLocalDataSource: serviceLocator(),
      profileRemoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(flutterSecureStorage: serviceLocator()),
  );

  //! Feature AlertDialog
  serviceLocator.registerFactory(
    () => AlertDialogBloc(),
  );

  // feature 16 Change Password and Change Username
  //bloc
  serviceLocator.registerFactory(
    () => UsernameBloc(
        changeUsernameUsecase: serviceLocator(),
        changeUserAvatarUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => PasswordBloc(changePasswordusecase: serviceLocator()),
  );

  //usecase
  serviceLocator.registerLazySingleton(
    () => ChangeUsernameUsecase(profileRepositories: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => ChangePasswordusecase(profileRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ChangeUserAvatarUsecase(profileRepositories: serviceLocator()),
  );

  //! Core ----------------------------------
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        internetConnectionChecker: serviceLocator(),
      ));

  //! External-----------------------------------
  const flutterSecureStorage = FlutterSecureStorage();
  serviceLocator.registerFactory(() => flutterSecureStorage);

  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
