import 'dart:math';

import 'package:dio/dio.dart';
import 'package:expense_tracker/features/Expense/expense.dart';
import 'package:expense_tracker/features/profile/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatbotService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl : 'https://api.groq.com/openai/v1/',
    headers: {
      'Authorization' : 'Bearer ${dotenv.env['GROQ_API_KEY']}',
      'Content_Type' : 'application/json' ,
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static const Map<int, String> _categoryMap = {
    1: 'Food',
    2: 'Shopping',
    3: 'Transport',
    4: 'Salary',
    5: 'Entertainment',
    6: 'Other',
  };



  String _buildcontext(Profile profile , List<Expense> expense){
    final buffer = StringBuffer();

    buffer.writeln("User : ${profile.user_name}");
    buffer.writeln("Monthly income : ${profile.income_montly}");
    buffer.writeln("saving percentges : ${profile.savingsGoalPerc}");

    buffer.writeln();

    final debits = expense.where((exp) =>  !exp.is_credited).toList();
    final credits = expense.where((exp) => exp.is_credited).toList();

    buffer.writeln("----Expenses---");
    if(debits.isEmpty){
      buffer.writeln("no expenses");
    }else{
      for(final exp in debits){
        final category = _categoryMap[exp.category_id] ;
        final date = exp.created_at.toLocal().toString().split(" ")[0];
        final amount = exp.amount;
        final note = exp.note ?? " ";
        buffer.writeln("expense : ${category} - ${date} - ${amount} - ${note}");
      }
    }

    buffer.writeln("----Income---");
    if(credits.isEmpty){
      buffer.writeln("no income");
    }else{


        for (final e in credits) {
          final date = e.created_at.toLocal().toString().split(' ')[0];
          buffer.writeln('- $date | ₹${e.amount} | ${e.title}');
        }

    }

    return buffer.toString();




  }


  Future<String> sendMessage({
    required List<Map<String, String>> history,
    required List<Expense> expenses,
    required Profile profile,
  }) async {
    final context = _buildcontext( profile , expenses);

    final systemPrompt = '''
You are a personal finance assistant inside the Expenso app.
Here is the user's financial data for the last 30 days:

$context

Rules:
- Only answer questions related to their expenses, income, budget, or savings.
- If asked anything unrelated, reply exactly: "I can only help with your expense related questions."
- Use ₹ for currency.
- Be concise and helpful.
''';

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...history,
    ];

    final response = await _dio.post(
      'chat/completions',
      data: {
        'model': 'llama-3.3-70b-versatile',
        'messages': messages,
        'max_tokens': 1000,
        'temperature': 0.7,
      },
    );

    return response.data['choices'][0]['message']['content'] as String;
  }
}

