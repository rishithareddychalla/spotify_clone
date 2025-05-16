import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_clone/models/editors_pick_model.dart';

class PlaylistDetailsNotifier extends StateNotifier<PlaylistDetailsState> {
  PlaylistDetailsNotifier() : super(PlaylistDetailsState());

  Future<void> getPlaylistDetails(String token, String playlistId) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final response = await http.get(
        Uri.parse(
          'https://apis2.ccbp.in/spotify-clone/playlists-details/$playlistId',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final playlistDetails = PlaylistDetails.fromJson(json);
        state = state.copyWith(
          isLoading: false,
          playlistDetails: playlistDetails,
          errorMessage: '',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load playlist: ${response.statusCode}',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load playlist: $e',
      );
    }
  }
}

final playlistDetailsProvider =
    StateNotifierProvider<PlaylistDetailsNotifier, PlaylistDetailsState>(
      (ref) => PlaylistDetailsNotifier(),
    );

class PlaylistDetailsState {
  final bool isLoading;
  final String errorMessage;
  final PlaylistDetails? playlistDetails;

  PlaylistDetailsState({
    this.isLoading = false,
    this.errorMessage = '',
    this.playlistDetails,
  });

  PlaylistDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    PlaylistDetails? playlistDetails,
  }) {
    return PlaylistDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      playlistDetails: playlistDetails ?? this.playlistDetails,
    );
  }
}
