import 'package:expense_tracker/common/functions/CurrencyFormater.dart';
import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:expense_tracker/features/profile/presentation/pages/prodileEditingPage.dart';
import 'package:expense_tracker/features/profile/provider/profile_provider.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/dangerZone.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  String getInitials(String? name, String? email) {
    if (name != null && name.isNotEmpty && name != "Unknown") {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }
    return email?[0].toUpperCase() ?? '?';
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final avatarurl = user?.userMetadata?['avatar_url'];
    final username = user?.userMetadata?['name'] ?? "Unknown";
    final email = user?.email;

    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppPallete.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppPallete.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileEditingPage()),
              );
            },
            icon: Icon(Icons.edit, size: 20.sp),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [

            /// 🔵 Avatar Section
            SizedBox(height: 10.h),

            CircleAvatar(
              radius: 48.r,
              backgroundColor: AppPallete.primaryBlue.withOpacity(0.15),
              child: CircleAvatar(
                radius: 44.r,
                backgroundImage:
                avatarurl != null ? NetworkImage(avatarurl) : null,
                backgroundColor: AppPallete.primaryBlue,
                child: avatarurl == null
                    ? Text(
                  getInitials(username, email),
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.background,
                  ),
                )
                    : null,
              ),
            ),

            SizedBox(height: 14.h),

            /// 🔤 Username
            profileAsync.when(
              data: (profile) => Text(
                (profile?.user_name?.isNotEmpty ?? false)
                    ? profile!.user_name
                    : username,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.textPrimary,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text("Error"),
            ),

            SizedBox(height: 28.h),

            /// 🧾 Personal Info Card
            _buildCard(
              title: "Personal Info",
              child: profileAsync.when(
                data: (profile) {
                  return Column(
                    children: [
                      _row("Name",
                          profile?.user_name ?? username, Icons.person),

                      _divider(),

                      _row("Email", email ?? "No Email", Icons.email),

                      _divider(),

                      _row(
                        "Phone",
                        profile?.phone_no != 0
                            ? "${profile?.phone_no}"
                            : "Not set",
                        Icons.phone,
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text("Error loading"),
              ),
            ),

            SizedBox(height: 16.h),

            /// 💰 Finance Card
            _buildCard(
              title: "Finances",
              child: profileAsync.when(
                data: (profile) {
                  if (profile == null) {
                    return const Text("No data");
                  }

                  return Column(
                    children: [
                      _row(
                        "Monthly Income",
                        CurrencyFormatter.format(profile.income_montly),
                        Icons.account_balance_wallet,
                      ),

                      _divider(),

                      _row(
                        "Saving Goal",
                        "${profile.savingsGoalPerc}%",
                        Icons.savings,
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text("Error loading"),
              ),
            ),

            SizedBox(height: 16.h),

            /// ⚠️ Danger Zone
            dangerZone(context, ref),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  /// 🔹 Card Widget
  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppPallete.textSecondary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  /// 🔹 Row Widget (Professional)
  Widget _row(String title, String info, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            height: 42.h,
            width: 42.h,
            decoration: BoxDecoration(
              color: AppPallete.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: AppPallete.primaryBlue,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppPallete.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  info,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Divider
  Widget _divider() {
    return Divider(
      height: 18.h,
      thickness: 0.6,
      color: AppPallete.textSecondary.withOpacity(0.15),
    );
  }
}