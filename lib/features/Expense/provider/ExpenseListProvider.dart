

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../profile/provider/profile_provider.dart';
import '../Services/expense_services.dart';
import '../expense.dart';
final expenseServicesProvider = Provider<ExpenseServices>((ref) => ExpenseServices());

final ItemListProvider  =  StateNotifierProvider<ItemNotifier,List<Expense>>((ref) {
  return ItemNotifier(ref.read(expenseServicesProvider));
});


class ItemNotifier extends StateNotifier<List<Expense>>{
  final ExpenseServices _services;

  ItemNotifier(this._services) : super([]) {
   fetchExpenses(); // ✅ load from Supabase when app starts
  }



  Future<void> addItem(
      String title , int amount  , String note ,
      DateTime date , bool is_credited ) async{
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final Item = Expense(
        user_id : user.id , id: '', title: title , amount: amount,
        note: note, created_at:  date, is_credited: is_credited);

    await _services.addExpense(Item);
    await fetchExpenses();




  }
  Future<void> fetchExpenses() async {
    final expenses = await _services.fetchExpenses();
    state = expenses; // ✅ actually updates state
  }

  Future<void> updateItem(Expense updatedExpense) async {
    await _services.updateExpense(updatedExpense);
    await fetchExpenses();
  }
  Future<void> deleteExpense(String id ) async{
    await _services.deleteExpense(id);
    await fetchExpenses();

  }






}

final monthlyBudgetProvider = Provider<int>((ref) {
  final profile = ref.watch(profileProvider);

  return profile.when(
    data: (profile) {
      if (profile == null) return 0;
      final savings = (profile.income_montly * profile.savingsGoalPerc / 100).toInt();
      return profile.income_montly - savings; // ✅ spendable budget
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final incomeProvider = StateProvider<int>((ref) {
  final list = ref.watch(ItemListProvider);
  return list.where(
      (e) => e.is_credited
  ).fold(0, (sum , e) => sum + e.amount) ;
  
});

final expenseProvider = StateProvider<int>((ref){
  final list = ref.watch(ItemListProvider);
  return list.where( (e) => !e.is_credited).fold(0 , (sum , e) => sum + e.amount);

} );

final budgetProvider = StateProvider<int>((ref) {

  final income = ref.watch(incomeProvider);
  final expense = ref.watch(expenseProvider);
  final budget = ref.watch(monthlyBudgetProvider);

  return budget + income - expense;

});