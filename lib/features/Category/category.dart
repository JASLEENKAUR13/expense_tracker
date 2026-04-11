class Category {
  final int id;
  final String name;
  final String icon_name;
  final String color_hex;
  final DateTime created_at;

  Category({
    required this.id,
    required this.name,
    required this.icon_name,
    required this.color_hex,
    required this.created_at,
  });

  // Convert JSON from database to Category object
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    icon_name: json['icon_name'],
    color_hex: json['color_hex'],
    created_at: DateTime.parse(json['created_at']),
  );

  // Convert Category object to JSON for database
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon_name': icon_name,
    'color_hex': color_hex,
    'created_at': created_at.toIso8601String(),
  };
}