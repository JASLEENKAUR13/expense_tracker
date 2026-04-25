import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.auth.onAuthStateChange.map(
        (event) {
      print("AUTH EVENT: ${event.event}");
      final user = event.session?.user ?? supabase.auth.currentUser;
      print("USER: ${user?.email}");
      return user;
    },
  );
});