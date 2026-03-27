import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Expense/Presentation/pages/HomePage.dart';
import '../../profile/presentation/profilesetup.dart';
import '../../profile/provider/profile_provider.dart';
import '../Services/AuthflowScreen.dart';
import '../Services/provider/auth_provider.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authstate = ref.watch(authStateProvider);

    return authstate.when(
      data: (user) {
        if (user == null) return const AuthFlowScreen();

        // ✅ watching profileProvider now, not reading once
        final profileAsync = ref.watch(profileProvider);

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
              return const ProfileSetUp();
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