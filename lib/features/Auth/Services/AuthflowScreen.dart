import 'package:flutter/cupertino.dart';

import '../Presentation/Pages/OnboardingScreen.dart';
import '../Presentation/Pages/SignInPage.dart';
import '../Presentation/Pages/SignUpPage.dart';

class  AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  State<AuthFlowScreen> createState() =>_authFlowScreen();
}

class _authFlowScreen extends State<AuthFlowScreen> {

  bool showOnboarding = true;
  bool showSignUp = false;

  void finishOnboarding() {
    setState(() {
      showOnboarding = false;
    });
  }

  void toggleAuth() {
    setState(() {
      showSignUp = !showSignUp;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (showOnboarding) {
      return OnboardingScreen(onFinished: finishOnboarding);
    }

    return showSignUp
        ? SignUpPage(onSwitch: toggleAuth)
        : SignInPage(onSwitch: toggleAuth);
  }
}
