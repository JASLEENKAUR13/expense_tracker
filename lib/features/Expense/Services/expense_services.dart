
import 'package:supabase_flutter/supabase_flutter.dart';

import '../expense.dart';
import 'BudgetPeriod.dart';

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

  Future<void> updateExpense(Expense expense) async {
    await supabase
        .from('expenses')
        .update(expense.toJson())
        .eq('id', expense.id);
  }

  Future<void> deleteExpense(String id) async{
    await supabase.from('expenses').delete().eq('id', id);
  }

  Future<List<Expense>> fetchCurrentPeriodExpenses(int salaryDay) async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    // ✅ get current period dates
    final period = getCurrentBudgetPeriod(salaryDay);

    final res = await supabase
        .from('expenses')
        .select()
        .eq('user_id', user.id)
        .gte('created_at', period.start.toIso8601String())
        .lte('created_at', period.end.toIso8601String())
        .order('created_at', ascending: false);

    return res.map((json) => Expense.fromJson(json)).toList();
  }


}