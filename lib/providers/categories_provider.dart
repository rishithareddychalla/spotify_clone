import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/api_services.dart';
import 'package:spotify_clone/models/categories_model.dart';

class CategoriesState {
  final List<Item> categories;
  final bool isLoading;
  final String errorMessage;

  CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage = "",
  });

  CategoriesState copyWith({
    List<Item>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CategoriesProvider extends StateNotifier<CategoriesState> {
  final ApiService apiService;

  CategoriesProvider(this.apiService) : super(CategoriesState());

  Future<void> getCategories(String token) async {
    state = state.copyWith(isLoading: true, errorMessage: "");
    try {
      final response = await apiService.fetchCategories(
        token,
      ); // Fixed: Use fetchCategories
      print('API Response: $response'); // Debug log
      if (response['status'] == 200) {
        final Categories categoriesData = Categories.fromJson(response['body']);
        print('Parsed Categories: $categoriesData'); // Debug log
        final List<Item> categoryList = categoriesData.categories.items;
        print('Parsed categories: $categoryList'); // Debug log
        state = state.copyWith(categories: categoryList, isLoading: false);
      } else {
        state = state.copyWith(
          errorMessage:
              response['body']['error_msg'] ?? 'Failed to load categories',
          isLoading: false,
        );
      }
    } catch (e) {
      print('Error in getCategories: $e'); // Debug log
      state = state.copyWith(
        errorMessage: 'Failed to load categories: $e',
        isLoading: false,
      );
    }
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesProvider, CategoriesState>(
      (ref) => CategoriesProvider(ApiService()),
    );
