

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../common/services/notification_services.dart';
import '../../profile/Services/profile_services.dart';
import '../../profile/provider/profile_provider.dart';
import '../Services/BudgetPeriod.dart';
import '../Services/expense_services.dart';
import '../expense.dart';
final expenseServicesProvider = Provider<ExpenseServices>((ref) => ExpenseServices());

final ItemListProvider  =  StateNotifierProvider<ItemNotifier,List<Expense>>((ref) {
  return ItemNotifier(ref.read(expenseServicesProvider) );
});


class ItemNotifier extends StateNotifier<List<Expense>>{
  final ExpenseServices _services;



  ItemNotifier(this._services ) : super([]) {
   fetchExpenses(); // ✅ load from Supabase when app starts
  }
  Future<void> addItem(
      String title, int amount, String note,
      DateTime date, bool is_credited, int category_id , int budget , int salaryday) async {
    print('🟡 addItem called'); // 👈 add this

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('🔴 user is null'); // 👈 add this
      return;
    }
    print('🟢 user found: ${user.id}'); // 👈 add this


    final Item = Expense(
        user_id: user.id, id: '', title: title, amount: amount,
        note: note, created_at: date, is_credited: is_credited,
        category_id: category_id);

    await _services.addExpense(Item);
    print('🟢 expense added to supabase'); // 👈 add this
    await fetchExpenses();
    print('🟢 expenses fetched');

    if (!is_credited) {
    final period = getCurrentBudgetPeriod(salaryday);
    final periodKey = "${period.start.year}-${period.start.month.toString().padLeft(2, '0')}";

    // get current profile
    final profile = await ProfileServices().getProfile();
    if (profile == null) return;

    // check if new period started → reset flag
    bool alertSent = profile.budget_alert_sent;
    if (profile.budget_alert_period != periodKey) {
    // new period → reset
    alertSent = false;
    await ProfileServices().updateBudgetAlert(
    alertSent: false,
    alertPeriod: periodKey,
    );
    }

    // only check if alert not sent yet
    if (!alertSent) {
    final spent = state
        .where((e) =>
    !e.is_credited &&
    e.created_at.isAfter(period.start.subtract(const Duration(days: 1))) &&
    e.created_at.isBefore(period.end.add(const Duration(days: 1))))
        .fold(0, (sum, e) => sum + e.amount);

    if (budget > 0 && spent >= (budget * 0.8).toInt()) {
    final remaining = budget - spent;
    await NotificationService.showBudgetAlert(
    remaining >= 0
    ? "You've used 80% of your budget! ₹$remaining left."
        : "⚠️ You've exceeded your budget by ₹${remaining.abs()}!"
    );

    // save flag so it doesn't show again this period
    await ProfileServices().updateBudgetAlert(
    alertSent: true,
    alertPeriod: periodKey,
    );
    }
    }
    }
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

// ✅ Income for current period only
final currentIncomeProvider = Provider<int>((ref) {
  final list = ref.watch(currentPeriodExpenseProvider);
  return list
      .where((e) => e.is_credited)
      .fold(0, (sum, e) => sum + e.amount);
});

final currentExpenseProvider = Provider<int>((ref) {
  final list = ref.watch(currentPeriodExpenseProvider);
  return list
      .where((e) => !e.is_credited)
      .fold(0, (sum, e) => sum + e.amount);
});

// ✅ Remaining budget for current period
final currentBudgetProvider = Provider<int>((ref) {
  final income = ref.watch(currentIncomeProvider);
  final expense = ref.watch(currentExpenseProvider);
  final budget = ref.watch(monthlyBudgetProvider);
  return budget  - expense;
});

final salaryDayProvider = Provider<int>((ref) {
  final profile = ref.watch(profileProvider);
  return profile.when(
    data: (profile) => profile?.salary_day ?? 1,
    loading: () => 1,
    error: (_, __) => 1,
  );
});

final currentPeriodExpenseProvider = Provider<List<Expense>>((ref) {
  // ✅ watches ItemListProvider — auto refreshes on any change!
  final allExpenses = ref.watch(ItemListProvider);

  final profile = ref.watch(profileProvider);

  return profile.when(
    data: (profile) {
      if (profile == null) return [];

      // ✅ get current period dates
      final period = getCurrentBudgetPeriod(profile.salary_day);

      // ✅ filter from already fetched list — no extra Supabase call!
      return allExpenses.where((e) {
        return e.created_at.isAfter(
            period.start.subtract(const Duration(days: 1))) &&
            e.created_at.isBefore(
                period.end.add(const Duration(days: 1)));
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});