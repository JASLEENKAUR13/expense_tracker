import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Holds extracted data from a receipt image
class ExtractedExpenseData {
  final String? title;
  final double? amount;
  final String? categoryName;
  final String? note;
  final DateTime? date;

  ExtractedExpenseData({
    this.title,
    this.amount,
    this.categoryName,
    this.note,
    this.date,
  });
}

class GeminiService {
  // 🔑 Groq API key — get free at console.groq.com
  static final String? _apiKey = dotenv.env['GROQ_API_KEY'];
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.1-8b-instant'; // free, fast, works in India ✅

  // Your 6 categories — keep in sync with Supabase
  static const List<String> _categories = [
    'Food',
    'Shopping',
    'Transport',
    'Salary',
    'Entertainment',
    'Other',
  ];

  // ─────────────────────────────────────────────────────────────
  // FLOW 1 — Smart Categorization while typing title
  // ─────────────────────────────────────────────────────────────
  Future<String?> suggestCategory(String title) async {
    if (title
        .trim()
        .isEmpty) return null;

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content':
              'You are a smart expense categorizer for an Indian expense tracking app. '
                  'You ONLY reply with one word — the category name. Nothing else.',
            },
            {
              'role': 'user',
              'content':
              'Expense title: "$title"\n\n'
                  'Pick the MOST suitable category from ONLY these options:\n'
                  '${_categories.join(', ')}\n\n'
                  'Rules:\n'
                  '- Return ONLY the category name, nothing else\n'
                  '- No punctuation, no explanation\n'
                  '- If unsure, return Other\n'
                  '- Examples: Dominos → Food, Uber → Transport, Amazon → Shopping, PVR → Entertainment',
            }
          ],
          'temperature': 0.1,
          'max_tokens': 10,
        }),
      );

      print('📡 Groq status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['choices']?[0]?['message']?['content']
            ?.toString()
            .trim();

        print('✅ Groq suggested: $result');

        if (result != null && _categories.contains(result)) {
          return result;
        }
        return 'Other';
      } else {
        print('❌ Groq error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('GeminiService.suggestCategory error: $e');
    }
    return null;
  }
}