import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/api_services.dart';
import 'package:spotify_clone/models/featured_playlists_model.dart';

class FeaturedState {
  final List<Item> featured;
  final bool isLoading;
  final String errorMessage;

  FeaturedState({
    this.featured = const [],
    this.isLoading = false,
    this.errorMessage = "",
  });

  FeaturedState copyWith({
    List<Item>? featured,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeaturedState(
      featured: featured ?? this.featured,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FeaturedPlaylistProvider extends StateNotifier<FeaturedState> {
  final ApiService apiService;

  FeaturedPlaylistProvider(this.apiService) : super(FeaturedState());

  Future<void> getFeatured(String token) async {
    state = state.copyWith(isLoading: true, errorMessage: "");
    try {
      final response = await apiService.fetchFeaturedPlaylists(token);

      if (response['status'] == 200) {
        final Featured featuredData = Featured.fromJson(response['body']);
        final List<Item> featuredPlaylists = featuredData.playlists.items;

        state = state.copyWith(featured: featuredPlaylists, isLoading: false);
      } else {
        state = state.copyWith(
          errorMessage:
              response['body']['error_msg'] ?? 'Failed to load playlists',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load playlists: $e',
        isLoading: false,
      );
    }
  }
}

final featuredProvider =
    StateNotifierProvider<FeaturedPlaylistProvider, FeaturedState>(
      (ref) => FeaturedPlaylistProvider(ApiService()),
    );
