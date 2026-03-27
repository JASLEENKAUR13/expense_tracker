import 'dart:async';
import 'package:expense_tracker/features/profile/Services/profile_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Auth/Services/provider/auth_provider.dart';
import '../profile.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  ProfileNotifier.new,
);



final profileServicesProvider =
Provider<ProfileServices>((ref) => ProfileServices());

class ProfileNotifier extends AsyncNotifier<Profile?> {
  final service = ProfileServices();

  @override
  FutureOr<Profile?> build() async {
    // ✅ watch auth state — re-runs whenever auth changes
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) async {
        if (user == null) return null; // logged out → return null
        print("FETCHING PROFILE FOR: ${user.id}"); // ✅ debug
        return await service.getProfile();
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
}
