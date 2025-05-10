import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryPlaylist {
  final String id;
  final String name;
  final List<Image> images;

  CategoryPlaylist({
    required this.id,
    required this.name,
    required this.images,
  });

  factory CategoryPlaylist.fromJson(Map<String, dynamic> json) {
    return CategoryPlaylist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => Image.fromJson(image))
              .toList() ??
          [],
    );
  }
}

class Image {
  final String url;

  Image({required this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(url: json['url'] ?? '');
  }
}

class CategoryPlaylistsState {
  final List<CategoryPlaylist> categoryPlaylists;
  final bool isLoading;
  final String errorMessage;

  CategoryPlaylistsState({
    this.categoryPlaylists = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  CategoryPlaylistsState copyWith({
    List<CategoryPlaylist>? categoryPlaylists,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryPlaylistsState(
      categoryPlaylists: categoryPlaylists ?? this.categoryPlaylists,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CategoryPlaylistsNotifier extends StateNotifier<CategoryPlaylistsState> {
  CategoryPlaylistsNotifier() : super(CategoryPlaylistsState());

  Future<void> getCategoryPlaylists(String token, String categoryId) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final url =
        'https://apis2.ccbp.in/spotify-clone/category-playlists/$categoryId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      log('Category Playlists API Response Status: ${response.statusCode}');
      log('Category Playlists API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final playlists =
            (data['playlists']['items'] as List<dynamic>?)
                ?.map((item) => CategoryPlaylist.fromJson(item))
                .toList() ??
            [];
        state = state.copyWith(categoryPlaylists: playlists, isLoading: false);
      } else {
        final errorData = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to load category playlists: ${response.statusCode} - ${errorData['error_msg'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Category Playlists API Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error fetching category playlists: $e',
      );
    }
  }
}

final categoryPlaylistsProvider =
    StateNotifierProvider<CategoryPlaylistsNotifier, CategoryPlaylistsState>(
      (ref) => CategoryPlaylistsNotifier(),
    );
