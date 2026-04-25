class BudgetPeriod {
  final DateTime start;
  final DateTime end;

  BudgetPeriod({required this.start, required this.end});
}

BudgetPeriod getCurrentBudgetPeriod(int salaryDay) {
  final today = DateTime.now();

  // ✅ Handle months with fewer days (Feb, etc.)
  // If salary day is 30 but month only has 28 days → use last day
  int safeDayForMonth(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return day > lastDay ? lastDay : day;
  }

  // ✅ Calculate this month's salary date
  final thisPeriodStart = DateTime(
    today.year,
    today.month,
    safeDayForMonth(today.year, today.month, salaryDay),
  );

  if (today.isBefore(thisPeriodStart)) {
    // Today is BEFORE salary day this month
    // → period started LAST month
    final prevMonth = today.month == 1 ? 12 : today.month - 1;
    final prevYear = today.month == 1 ? today.year - 1 : today.year;

    final start = DateTime(
      prevYear,
      prevMonth,
      safeDayForMonth(prevYear, prevMonth, salaryDay),
    );

    final end = thisPeriodStart.subtract(const Duration(days: 1));

    return BudgetPeriod(start: start, end: end);
  } else {
    // Today is ON or AFTER salary day this month
    // → period started THIS month
    final nextMonth = today.month == 12 ? 1 : today.month + 1;
    final nextYear = today.month == 12 ? today.year + 1 : today.year;

    final end = DateTime(
      nextYear,
      nextMonth,
      safeDayForMonth(nextYear, nextMonth, salaryDay),
    ).subtract(const Duration(days: 1));

    return BudgetPeriod(start: thisPeriodStart, end: end);
  }
}