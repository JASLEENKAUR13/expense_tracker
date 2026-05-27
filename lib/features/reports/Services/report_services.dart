import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Presentation/report_popup.dart';


const _snoozeKey = 'report_snooze_date';

Future<void> checkAndShowReportPopup(BuildContext context) async {
  print('🔍 checkAndShowReportPopup called');
  // 1. Check snooze — if user tapped "Later" today, skip
  final prefs = await SharedPreferences.getInstance();
  final snoozedDate = prefs.getString(_snoozeKey);
  final today = DateTime.now().toIso8601String().substring(0, 10); // "2026-05-16"
  print('📅 today: $today | snoozed: $snoozedDate');

  if (snoozedDate == today) {
    print('😴 snoozed today, skipping');
    return;
  } // snoozed today, don't show

  // 2. Get current user
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return;

  // 3. Query latest unread report for this user
  final response = await Supabase.instance.client
      .from('reports')
      .select('id, html_content, week_start, week_end')
      .eq('user_id', userId)
      .eq('is_read', false)
      .order('created_at', ascending: false)
      .limit(1)
      .maybeSingle();
  print('📊 report response: $response');
  if (response == null) return; // no unread report, nothing to show

  // 4. Show popup
  if (context.mounted) {
    print('✅ showing popup');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReportPopup(
        reportId: response['id'],
        htmlContent: response['html_content'],
        weekStart: response['week_start'],
        weekEnd: response['week_end'],
      ),
    );
  }
}

// Call this when user taps "Later"
Future<void> snoozeReportUntilTomorrow() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().substring(0, 10);
  await prefs.setString(_snoozeKey, today);
}

// Call this when user reads or downloads
Future<void> markReportAsRead(int reportId) async {
  await Supabase.instance.client
      .from('reports')
      .update({'is_read': true})
      .eq('id', reportId);
}