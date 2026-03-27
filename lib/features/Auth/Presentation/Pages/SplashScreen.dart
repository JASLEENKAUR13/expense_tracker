import 'package:flutter/material.dart';
import '../../../../common/theme/AppPallete.dart'; // Ensure this path matches your project

class MySplashScreenUI extends StatelessWidget {
  const MySplashScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background, // Uses your custom background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your App Branding
            Text(
              "EXPENSO",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppPallete.primaryBlue, // Your brand's blue
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            // A professional spinner that matches your theme
            const CircularProgressIndicator(
              color: AppPallete.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}