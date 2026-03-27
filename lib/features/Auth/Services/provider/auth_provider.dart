import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = Supabase.instance.client;

  return supabase.auth.onAuthStateChange.map(
        (event) {
      final session = event.session;
      print("AUTH EVENT: ${event.event}");
      print("SESSION USER: ${session?.user}");
      return session?.user;
    },
  );
});
