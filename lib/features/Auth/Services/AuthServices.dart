

import 'package:supabase_flutter/supabase_flutter.dart';




class Authservices {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> signInWithGoogle() async {
    try {
      final bool result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.expensetracker://login-callback/',
      );

      return result;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return false;
    }
  }

  Future<AuthResponse> signInWithEmail(String email , String password) async {
    try{
      final response = await _supabase.auth.signInWithPassword(email: email ,
  password: password);
      return response;
  }catch(e){
  print("Sign Up Error: $e");
  rethrow;

  }}

    Future<User?> signUpWithEmail(String email , String password) async {
      try{
        final response = await _supabase.auth.signUp(email: email ,
            password: password ,
          emailRedirectTo: 'io.supabase.expensetracker://login-callback/',);
        return response.user;
      }catch(e){
        print("Sign Up Error: $e");
        rethrow;

      }



}








}