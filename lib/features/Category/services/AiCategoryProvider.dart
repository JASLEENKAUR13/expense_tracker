import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../category.dart';
import '../provider/CategoryProvider.dart';
import 'gemini_services.dart';

// ─────────────────────────────────────────────────────────────
// Provides the GeminiService instance (singleton)
// ─────────────────────────────────────────────────────────────
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

// ─────────────────────────────────────────────────────────────
// State for AI category suggestion
// ─────────────────────────────────────────────────────────────
enum AiCategoryStatus { idle, loading, done, error }

class AiCategoryState {
  final AiCategoryStatus status;
  final int? suggestedCategoryId; // maps to your DB id
  final String? suggestedCategoryName;

  const AiCategoryState({
    this.status = AiCategoryStatus.idle,
    this.suggestedCategoryId,
    this.suggestedCategoryName,
  });

  AiCategoryState copyWith({
    AiCategoryStatus? status,
    int? suggestedCategoryId,
    String? suggestedCategoryName,
  }) {
    return AiCategoryState(
      status: status ?? this.status,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      suggestedCategoryName:
      suggestedCategoryName ?? this.suggestedCategoryName,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Notifier — handles debounce + Gemini call + category mapping
// ─────────────────────────────────────────────────────────────
class AiCategoryNotifier extends StateNotifier<AiCategoryState> {
  final GeminiService _geminiService;
  final List<Category> _categories;

  AiCategoryNotifier(this._geminiService, this._categories)
      : super(const AiCategoryState());

  // Debounce timer
  Future<void>? _debounce;

  /// Call this every time title text changes
  /// Waits 500ms after user stops typing before calling Gemini
  void onTitleChanged(String title) {
    // Reset if empty
    if (title.trim().length < 3) {
      state = const AiCategoryState(status: AiCategoryStatus.idle);
      return;
    }

    // Show loading immediately for snappy feel
    state = state.copyWith(status: AiCategoryStatus.loading);

    // Debounce: cancel previous, wait 500ms
    _debounce = Future.delayed(const Duration(milliseconds: 500), () async {
      await _suggest(title);
    });
  }

  Future<void> _suggest(String title) async {
    try {
      final categoryName = await _geminiService.suggestCategory(title);

      if (categoryName == null) {
        state = const AiCategoryState(status: AiCategoryStatus.idle);
        return;
      }

      // Map category name → your DB category id
      final match = _categories.firstWhere(
            (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => _categories.firstWhere(
              (c) => c.name == 'Other',
          orElse: () => _categories.last,
        ),
      );

      state = AiCategoryState(
        status: AiCategoryStatus.done,
        suggestedCategoryId: match.id,
        suggestedCategoryName: match.name,
      );
    } catch (e) {
      state = const AiCategoryState(status: AiCategoryStatus.error);
    }
  }

  /// Call this to reset (e.g. user manually picks a category)
  void reset() {
    state = const AiCategoryState(status: AiCategoryStatus.idle);
  }
}

// ─────────────────────────────────────────────────────────────
// Provider — wires GeminiService + categories list together
// ─────────────────────────────────────────────────────────────
final aiCategoryProvider =
StateNotifierProvider<AiCategoryNotifier, AiCategoryState>((ref) {
  final gemini = ref.watch(geminiServiceProvider);
  // Reuse your existing categoryProvider list
  final categories = ref.watch(categoryProvider);
  return AiCategoryNotifier(gemini, categories);
});

// ─────────────────────────────────────────────────────────────
// NOTE: Import your existing categoryProvider at the top
// Example: import '../../../Category/provider/CategoryProvider.dart';
// and replace `categoryProvider` above with your actual provider name
// ─────────────────────────────────────────────────────────────