class Profile {

  final String id ;
  final String email;
  final int income_montly;
  final int savingsGoalPerc;
  final DateTime updated_at;
  final String user_name;
  final int phone_no;

  Profile({required this.id , required this.email , required this.income_montly ,
    required this.savingsGoalPerc, required this.updated_at, required this.user_name, required this.phone_no ,});

  factory Profile.fromJson(Map<String , dynamic> json){
    // supabase sends data in map , we r coverting that map into object
    return Profile(
    id : json['id'], email: json['email'],
      income_montly: json['monthly_income'] ?? 0,
      savingsGoalPerc: json['savings_goal_percent'] ?? 0,
      updated_at: DateTime.parse(json['updated_at']),
      user_name: json['user_name'] ?? '',
      phone_no: json['phone_no'] ?? 0,

    );
  }

  Map<String , dynamic> toJson(){
    //to talk to supabase object -> map
    return{
      'id' : id ,
      'email' : email,
      'monthly_income' : income_montly.toInt(),
      'savings_goal_percent' : savingsGoalPerc.toInt(),
      'updated_at' : updated_at.toIso8601String(),
      'user_name' : user_name,
      'phone_no' : phone_no,


    };

  }

  Profile copyWith({
    // to update the profile model from application
    String? id ,
    String? email,
     int? income_montly,
     int? savingsGoalPerc,
     DateTime? updated_at,
    String? user_name,
    int? phone_no,

}

){
    return Profile(id: id ?? this.id,
        email: email ?? this.email,
        income_montly: income_montly ?? this.income_montly,
        savingsGoalPerc: savingsGoalPerc ?? this.savingsGoalPerc,
        updated_at: updated_at?? this.updated_at,
        user_name: user_name?? this.user_name,
        phone_no: phone_no ?? this.phone_no);

  }


}