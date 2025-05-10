import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/models/editors_pick_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistDetailsState {
  final PlaylistDetails? playlistDetails;
  final bool isLoading;
  final String errorMessage;

  PlaylistDetailsState({
    this.playlistDetails,
    this.isLoading = false,
    this.errorMessage = '',
  });

  PlaylistDetailsState copyWith({
    PlaylistDetails? playlistDetails,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlaylistDetailsState(
      playlistDetails: playlistDetails ?? this.playlistDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PlaylistDetailsNotifier extends StateNotifier<PlaylistDetailsState> {
  PlaylistDetailsNotifier() : super(PlaylistDetailsState());

  Future<void> getPlaylistDetails(String token, String playlistId) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final url =
        'https://apis2.ccbp.in/spotify-clone/playlists-details/$playlistId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      log('Playlist Details API Response Status: ${response.statusCode}');
      log('Playlist Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final playlistDetails = PlaylistDetails.fromJson(data);
        state = state.copyWith(
          playlistDetails: playlistDetails,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to load playlist details: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Playlist Details API Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error fetching playlist details: $e',
      );
    }
  }
}

final playlistDetailsProvider =
    StateNotifierProvider<PlaylistDetailsNotifier, PlaylistDetailsState>(
      (ref) => PlaylistDetailsNotifier(),
    );
