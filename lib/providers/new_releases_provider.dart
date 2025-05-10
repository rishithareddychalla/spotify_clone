import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/api_services.dart';

import 'package:spotify_clone/models/new_releases_model.dart';

class AlbumsState {
  final List<Item> albums;
  final bool isLoading;
  final String errorMessage;

  AlbumsState({
    this.albums = const [],
    this.isLoading = false,
    this.errorMessage = "",
  });

  AlbumsState copyWith({
    List<Item>? albums,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AlbumsState(
      albums: albums ?? this.albums,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AlbumsProvider extends StateNotifier<AlbumsState> {
  final ApiService apiService;

  AlbumsProvider(this.apiService) : super(AlbumsState());

  Future<void> getAlbums(String token) async {
    state = state.copyWith(isLoading: true, errorMessage: "");
    try {
      final response = await apiService.fetchNewReleases(token);
      print('Albums API Response: $response'); // Debug log
      print('Response body: ${response['body']}'); // Debug log
      print('Response body type: ${response['body'].runtimeType}'); // Debug log
      if (response['status'] == 200) {
        final Releases albumsData = Releases.fromJson(response['body']);
        print('Parsed Albums: $albumsData'); // Debug log
        final List<Item> albumItems = albumsData.albums.items;
        print('Parsed album items: $albumItems'); // Debug log
        state = state.copyWith(albums: albumItems, isLoading: false);
      } else {
        state = state.copyWith(
          errorMessage:
              response['body']['error_msg'] ?? 'Failed to load albums',
          isLoading: false,
        );
      }
    } catch (e) {
      print('Error in getAlbums: $e'); // Debug log
      state = state.copyWith(
        errorMessage: 'Failed to load albums: $e',
        isLoading: false,
      );
    }
  }
}

final albumsProvider = StateNotifierProvider<AlbumsProvider, AlbumsState>(
  (ref) => AlbumsProvider(ApiService()),
);
