class Profile {

  final String id ;
  final String email;
  final int income_montly;
  final int savingsGoalPerc;
  final DateTime updated_at;
  final String user_name;
  final int phone_no;
  final int salary_day;
  final bool budget_alert_sent;
  final String budget_alert_period;

  Profile({required this.id ,
    required this.email , required this.income_montly ,
    required this.savingsGoalPerc, required this.updated_at,
    required this.user_name, required this.phone_no,
    required this.salary_day, required this.budget_alert_sent,
    required this.budget_alert_period ,});

  factory Profile.fromJson(Map<String , dynamic> json){
    // supabase sends data in map , we r coverting that map into object
    return Profile(
    id : json['id'], email: json['email'],
      income_montly: json['monthly_income'] ?? 0,
      savingsGoalPerc: json['savings_goal_percent'] ?? 0,
      updated_at: DateTime.parse(json['updated_at']),
      user_name: json['user_name'] ?? '',
      phone_no: json['phone_no'] ?? 0,
      salary_day: json['salary_day'] ?? 1,
        budget_alert_sent: json['budget_alert_sent'] ?? false,
        budget_alert_period: json['budget_alert_period'] ?? ""


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
      'salary_day' : salary_day,
      'budget_alert_sent': budget_alert_sent ,
      'budget_alert_period': budget_alert_period ,



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
    int? salary_day,
    bool? budget_alert_sent,
    String? budget_alert_period,

}

){
    return Profile(id: id ?? this.id,
        email: email ?? this.email,
        income_montly: income_montly ?? this.income_montly,
        savingsGoalPerc: savingsGoalPerc ?? this.savingsGoalPerc,
        updated_at: updated_at?? this.updated_at,
        user_name: user_name?? this.user_name,
        phone_no: phone_no ?? this.phone_no,
        salary_day: salary_day ?? this.salary_day ,
        budget_alert_sent: budget_alert_sent ?? this.budget_alert_sent ,
        budget_alert_period: budget_alert_period ?? this.budget_alert_period ,

    );

  }


}