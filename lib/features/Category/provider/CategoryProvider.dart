
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../category.dart';
import '../services/CategoryServices.dart';

final categoryServicesProvider = Provider<CategoryServices>(
      (ref) => CategoryServices(),
);


final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>(
      (ref) {
    return CategoryNotifier(ref.read(categoryServicesProvider));
  },
);

class CategoryNotifier extends StateNotifier<List<Category>> {
final CategoryServices _services;

CategoryNotifier(this._services) : super([]) {
fetchCategories(); // ✅ Load categories when app starts
}

// Fetch categories from database
Future<void> fetchCategories() async {
final categories = await _services.fetchCategories();
state = categories; // ✅ Updates the state
}

// Add a new category
Future<void> addCategory(Category category) async {
await _services.addCategory(category);
await fetchCategories(); // Refresh list
}
}