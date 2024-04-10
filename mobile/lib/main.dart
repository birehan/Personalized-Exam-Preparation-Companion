import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/utils/bloc_providers.dart';
import 'package:skill_bridge_mobile/core/utils/hive_boxes.dart';
import 'package:skill_bridge_mobile/core/widgets/Transistion_page.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/pages/updated_profile_page.dart';
import 'package:skill_bridge_mobile/firebase_options.dart';
import 'core/core.dart';
import 'features/profile/presentation/pages/profile_edit_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    await di.init();
    await serviceLocator<HiveBoxes>().initializeHive();
  } catch (e) {
    print('Failed to initialize Firebase $e');
  }

  await NotificationService().initNotifications();
  FlutterNativeSplash.remove();
  runApp(
    MultiBlocProvider(
      providers: registedBlocs(),
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
                  return const TransitionWithDragableIcon();
                  // return const ProfileEditPage();
                  // return const UpdatedProfilePage();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
