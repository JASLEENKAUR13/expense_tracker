
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/common/theme/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/services/notification_services.dart';

import 'features/Auth/Presentation/authwrapper.dart';
import 'features/profile/Services/profile_services.dart';



Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();

  OneSignal.initialize(dotenv.env["ONE_SIGNAL_APP_ID"]!);
  await OneSignal.Notifications.requestPermission(true);


  await NotificationService.init(); // 👈 add this line

  print('🔑 KEY FROM MAIN: ${dotenv.env["GEMINI_API_KEY"]}');

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,

  );

  await setupOneSignal(); // 👈 add this
  runApp(const ProviderScope(child: MyApp(),)
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375 , 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return MaterialApp(
          title: 'EXPENSO',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            primaryColor: AppPallete.primaryBlue,
            scaffoldBackgroundColor: AppPallete.background,
            cardColor: AppPallete.cardWhite,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppPallete.background,
              elevation: 0,
            ),
            inputDecorationTheme: AppTheme.inputDecorationTheme,
          ),

          home: child,
        );

      },
      child: const AuthWrapper(),
    );
  }
}
Future<void> setupOneSignal() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // OneSignal player_id
  OneSignal.User.pushSubscription.addObserver((state) async {
    final playerId = OneSignal.User.pushSubscription.id;
    print('🎯 OneSignal Player ID: $playerId');
    if (playerId != null) {
      await ProfileServices().saveOneSignalToken(playerId);
    }
  });

  // Also try getting it immediately
  final playerId = OneSignal.User.pushSubscription.id;
  if (playerId != null) {
    await ProfileServices().saveOneSignalToken(playerId);
  }
}
