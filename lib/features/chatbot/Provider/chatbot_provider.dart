
import 'package:expense_tracker/features/chatbot/Services/chatbot_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Expense/expense.dart';
import '../../profile/profile.dart';

final chatbotServices = Provider<ChatbotService>((ref) => ChatbotService());

final ChatbotProvider = StateNotifierProvider<chatbotNotifier , List<Map<String , String>>>((ref){

  final services = ref.watch(chatbotServices);
 return  chatbotNotifier (services);

});



class chatbotNotifier extends StateNotifier<List<Map<String , String>>> {
  final ChatbotService _services;
  chatbotNotifier(this._services) : super([]);


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    state = [...state];
  }


  Future<void> sendMessage(String message ,
      List<Expense> expenses ,
      Profile profile ) async {

    state = [...state , {'role' : 'user' ,'content' : message }];

    isLoading = true;

    try{
      final response = await _services.sendMessage(history: state, expenses: expenses, profile: profile);
      state = [...state , {'role'  : 'assistant' , 'content' : response}];
    }catch(e){
      state = [...state, {'role': 'assistant', 'content': 'Something went wrong. Try again.'}];
    }finally{
      _isLoading = false;

    }

  }

  void clearchat(){
    state = [];
  }


}