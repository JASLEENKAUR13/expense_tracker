import 'package:expense_tracker/features/Auth/Presentation/authwrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C183F),
      body: Center(
        child: Image.asset(
          "lib/pict/logo.png",
          width: 120, // 👈 YOU control size now
        ),
      ),
    );
  }
}