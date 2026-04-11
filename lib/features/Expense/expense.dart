class Expense{

final String id ;
final String user_id;
final String title;
final int amount;
final String note;

final DateTime created_at ;
final bool is_credited;
final int category_id;






  Expense({required this.id ,
    required this.title, required this.amount,
    required this.note , required this.created_at,
    required this.is_credited, required this.user_id,
    required this.category_id});

Expense copyWith({
  String? id ,
  String? user_id,

String? title ,

  int? amount,
  String? note,
  DateTime? created_at,
  bool? is_credited,
  int? category_id,




}){
return Expense(id : id?? this.id ,
    title : title?? this.title,
    amount: amount?? this.amount , note: note?? this.note,
    created_at: created_at?? this.created_at, is_credited: is_credited??
        this.is_credited, user_id: user_id?? this.user_id,
    category_id: category_id?? this.category_id );
}

Map<String , dynamic> toJson() =>{

  'user_id' : user_id,
  'title' : title,
  'amount': amount ,
  'note' : note,
  'created_at' : created_at.toIso8601String(),
  'is_credited' : is_credited,
  'category_id' : category_id,


};


factory Expense.fromJson(Map<String , dynamic> json) => Expense(
    id: json['id'].toString(),
    title: json['title'],
    amount: json['amount'],
    note: json['note'],
    created_at: DateTime.parse(json['created_at']),
    is_credited: json['is_credited'],
    user_id: json['user_id'],
category_id :json['category_id']
);

}


