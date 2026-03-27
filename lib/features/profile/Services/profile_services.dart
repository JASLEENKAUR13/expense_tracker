import 'package:supabase_flutter/supabase_flutter.dart';

import '../profile.dart';

class ProfileServices {
  final supabase = Supabase.instance.client;

  Future<Profile?> getProfile() async{

    final user= supabase.auth.currentUser;
    print("GETTING PROFILE FOR: ${user?.id}");

    if(user == null){
      return null;
    }

    final  res = await supabase.from('profiles').select()
    .eq('id' , user.id).maybeSingle();
    print("PROFILE RESULT: $res");

    if(res == null) return null;

    return Profile.fromJson(res);

}

Future<void> saveProfile({
    required int monthlyincome,
  required int savingGoalpert,

}) async {

    final user = supabase.auth.currentUser;
    if(user == null){
      return null;
    }

    final profile = Profile(
      id : user.id,
      email: user.email!,
      income_montly: monthlyincome,
      savingsGoalPerc: savingGoalpert,
      updated_at: DateTime.now(),
    );
    await supabase.from('profiles').upsert(profile.toJson());







}

  Future<bool> needsSetup() async {
    final profile = await getProfile();
    return profile == null ||
        profile.income_montly == 0 ||
        profile.savingsGoalPerc == 0;
  }

}