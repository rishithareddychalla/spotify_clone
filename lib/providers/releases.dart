import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spotify_clone/models/releases_model.dart';

class AlbumDetailsState {
  final AlbumDetails? albumDetails;
  final bool isLoading;
  final String errorMessage;

  AlbumDetailsState({
    this.albumDetails,
    this.isLoading = false,
    this.errorMessage = '',
  });

  AlbumDetailsState copyWith({
    AlbumDetails? albumDetails,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AlbumDetailsState(
      albumDetails: albumDetails ?? this.albumDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AlbumDetailsNotifier extends StateNotifier<AlbumDetailsState> {
  AlbumDetailsNotifier() : super(AlbumDetailsState());

  Future<void> getAlbumDetails(String token, String albumId) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final url = 'https://apis2.ccbp.in/spotify-clone/album-details/$albumId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      log('Album Details API Response Status: ${response.statusCode}');
      log('Album Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final albumDetails = AlbumDetails.fromJson(data);
        state = state.copyWith(albumDetails: albumDetails, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load album details: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Album Details API Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error fetching album details: $e',
      );
    }
  }
}

final albumDetailsProvider =
    StateNotifierProvider<AlbumDetailsNotifier, AlbumDetailsState>(
      (ref) => AlbumDetailsNotifier(),
    );
