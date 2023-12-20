import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/firebase_options.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'features/profile/presentation/bloc/logout/logout_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';
import 'core/core.dart';
import 'features/features.dart';
import 'features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  } catch (e) {
    print('Failed to initialize Firebase $e');
  }

  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => serviceLocator<AuthenticationBloc>(),
        ),
        BlocProvider<SignupFormBloc>(
          create: (_) => serviceLocator<SignupFormBloc>(),
        ),
        BlocProvider<ChangePasswordFormBloc>(
          create: (_) => serviceLocator<ChangePasswordFormBloc>(),
        ),
        BlocProvider<GetUserBloc>(
          create: (_) => serviceLocator<GetUserBloc>(),
        ),
        BlocProvider<AlertDialogBloc>(
          create: (_) => serviceLocator<AlertDialogBloc>(),
        ),
        BlocProvider<UserProfileBloc>(
          create: (_) => serviceLocator<UserProfileBloc>(),
        ),
        BlocProvider<UsernameBloc>(
          create: (_) => serviceLocator<UsernameBloc>(),
        ),
        BlocProvider<PasswordBloc>(
          create: (_) => serviceLocator<PasswordBloc>(),
        ),
        BlocProvider<UsersLeaderboardBloc>(
          create: (_) => serviceLocator<UsersLeaderboardBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: SafeArea(
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'Poppins'),
            child: DismissKeyboard(
              child: ResponsiveSizer(
                builder: (context, orientation, screenType) {
                  return AppRouter(
                    localDatasource:
                        serviceLocator<AuthenticationLocalDatasource>(),
                  );
                },
              ),
            ),
            // Timer(),
          ),
        ),
      ),
    );
  }
}
