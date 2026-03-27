
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/common/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/Auth/Presentation/authwrapper.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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

      home: const AuthWrapper(),
    );
  }
}

