import 'package:supabase_flutter/supabase_flutter.dart';
import '../category.dart';

class CategoryServices {
  final supabase = Supabase.instance.client;

  // Fetch all categories from database
  Future<List<Category>> fetchCategories() async {
    try {
      final res = await supabase
          .from('categories')
          .select()
          .order('id', ascending: true);

      return res.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Add a new category (if needed)
  Future<void> addCategory(Category category) async {
    try {
      await supabase.from('categories').insert({
        'name': category.name,
        'icon_name': category.icon_name,
        'color_hex': category.color_hex,
        'created_at': category.created_at.toIso8601String(),
      });
    } catch (e) {
      print('Error adding category: $e');
    }
  }
}