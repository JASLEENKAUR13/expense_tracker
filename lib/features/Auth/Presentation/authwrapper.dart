import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Expense/Presentation/pages/HomePage.dart';
import '../../profile/presentation/pages/profilesetup.dart';
import '../../profile/provider/profile_provider.dart';
import '../Services/AuthflowScreen.dart';
import '../Services/provider/auth_provider.dart';
import 'Pages/emailverificationScreen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(authStateProvider);

    return authstate.when(
      data: (user) {

        print("👤 USER: $user");
        print("📧 EMAIL CONFIRMED: ${user?.emailConfirmedAt}");

        if (user == null) {
          print("❌ user is null → showing AuthFlowScreen");
          return const AuthFlowScreen();
        }


        print("emailConfirmedAt: ${user.emailConfirmedAt}");
        print("user: ${user.email}");

        // ✅ EMAIL NOT VERIFIED
        print("do email verfiyy");

        if (user.emailConfirmedAt == null) {
          print("Email not verified");
          return EmailVerificationScreen();
        }
        print("Email not verified");



        // ✅ watching profileProvider now, not reading once
        final profileAsync = ref.watch(profileProvider);
        print("user existss");

        return profileAsync.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            body: Center(child: Text("Error: $e")),
          ),
          data: (profile) {
            if (profile == null ||
                profile.income_montly == 0 ||
                profile.savingsGoalPerc == 0) {
              return  ProfileSetUp();
            }
            return const MyHomePage();
          },
        );
      },
      error: (e, _) => Scaffold(
        body: Center(child: Text("Error: $e")),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}