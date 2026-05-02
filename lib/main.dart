
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/common/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/services/notification_services.dart';
import 'features/Auth/Presentation/Pages/SplashScreen.dart';
import 'features/Auth/Presentation/authwrapper.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // 👈 add this line
  await dotenv.load(fileName: ".env");
  print('🔑 KEY FROM MAIN: ${dotenv.env["GEMINI_API_KEY"]}');

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,


  );
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

