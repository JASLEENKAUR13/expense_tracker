import 'package:expense_tracker/features/Expense/Presentation/pages/AnalyticsPage.dart';
import 'package:expense_tracker/features/Expense/Presentation/pages/alltransactionpage.dart';
import 'package:expense_tracker/features/profile/presentation/pages/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../profile/provider/profile_provider.dart';
import '../../provider/ExpenseListProvider.dart';
import '../../../../common/theme/AppPallete.dart';
import '../../../Category/presentation/categoryPieChart.dart';
import '../widgets/listcard.dart';
import '../widgets/quickViewContainer.dart';
import 'add_expensePage.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final firstName = user?.email?.split('@').first ?? "there";

    return Scaffold(
      backgroundColor: AppPallete.background,

      // ── Drawer ───────────────────────────────────
      drawer: Drawer(
        backgroundColor: AppPallete.background,
        surfaceTintColor: Colors.transparent,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppPallete.primaryBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(Icons.account_balance_wallet_rounded,
                          color: AppPallete.primaryBlue, size: 22.sp),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expenso",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.textPrimary,
                          ),
                        ),
                        Text(
                          "Hi, $firstName 👋",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppPallete.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(color: AppPallete.surface.withOpacity(0.3), height: 1),
              SizedBox(height: 12.h),

              // Nav items
              _drawerItem(Icons.dashboard_rounded, "Dashboard", () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()),
                      (r) => false,
                );
              }),
              _drawerItem(Icons.receipt_long_rounded, "All Transactions", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>  AlltransactionPage()));
              }),
              _drawerItem(Icons.analytics_rounded, "Analytics", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AnalyticsPage()));
              }),

              const Spacer(),

              Divider(color: AppPallete.surface.withOpacity(0.3), height: 1),
              _drawerItem(Icons.person_rounded, "Profile", () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfilePage()));
              }, muted: true),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),

      // ── AppBar ───────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppPallete.background,
        elevation: 0,
        foregroundColor: AppPallete.textPrimary,
        titleSpacing: 0,
        title: Text(
          "Expenso",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddExpensepage()),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppPallete.primaryBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.add_rounded,
                  color: AppPallete.primaryBlue, size: 22.sp),
            ),
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────
      body: Consumer(
        builder: (context, ref, _) {
          final list = ref.watch(ItemListProvider);
          final recent = list.take(5).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),

                // Quick stats
                QuickViewContainer(),

                SizedBox(height: 24.h),

                // Empty state
                if (list.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: AppPallete.surface.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.receipt_long_rounded,
                                size: 36.sp,
                                color: AppPallete.textSecondary),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "No transactions yet",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Tap + to add your first expense",
                            style: GoogleFonts.poppins(
                              fontSize: 13.sp,
                              color: AppPallete.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                // Populated state
                else ...[
                  // Section header
                  _sectionHeader(
                    "Recent Transactions",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AlltransactionPage()),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  ListView.builder(
                    itemCount: recent.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) => ListCard(currentExp: recent[i]),
                  ),




                  SizedBox(height: 12.h),

                  CategoryPieChart(),

                  SizedBox(height: 32.h),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap,
      {bool muted = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 2.h),
      leading: Icon(icon,
          color: muted ? AppPallete.textSecondary : AppPallete.primaryBlue,
          size: 22.sp),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: muted ? AppPallete.textSecondary : AppPallete.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppPallete.textPrimary,
          ),
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              "See all",
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppPallete.primaryBlue,
              ),
            ),
          ),
      ],
    );
  }
}