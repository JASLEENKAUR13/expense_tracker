
import 'package:supabase_flutter/supabase_flutter.dart';

import '../expense.dart';

class ExpenseServices {

  final supabase = Supabase.instance.client;

  Future<void> addExpense(Expense exp) async {
    await supabase.from('expenses').insert(exp.toJson());
  }


  Future<List<Expense>> fetchExpenses() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];
    final res = await supabase.from('expenses').select()
        .eq('user_id', user.id).order('created_at', ascending: false);

    return res.map((json) => Expense.fromJson(json)).toList();
  }


}