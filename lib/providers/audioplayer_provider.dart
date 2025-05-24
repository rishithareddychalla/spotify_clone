// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:just_audio/just_audio.dart';

// /// State class for audio player, holding playback state and player instance.
// class AudioPlayerState {
//   final AudioPlayer audioPlayer;
//   final bool isPlaying;
//   final String? currentTrackId;
//   final String? errorMessage;

//   AudioPlayerState({
//     required this.audioPlayer,
//     this.isPlaying = false,
//     this.currentTrackId,
//     this.errorMessage,
//   });

//   AudioPlayerState copyWith({
//     bool? isPlaying,
//     String? currentTrackId,
//     String? errorMessage,
//   }) {
//     return AudioPlayerState(
//       audioPlayer: audioPlayer,
//       isPlaying: isPlaying ?? this.isPlaying,
//       currentTrackId: currentTrackId ?? this.currentTrackId,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }

// /// Notifier to manage audio playback with just_audio.
// class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
//   AudioPlayerNotifier() : super(AudioPlayerState(audioPlayer: AudioPlayer()));

//   /// Plays a track with the given trackId and previewUrl.
//   Future<void> playTrack(String trackId, String? previewUrl) async {
//     if (previewUrl == null || previewUrl.isEmpty) {
//       print('No preview URL for track: $trackId');
//       state = state.copyWith(
//         errorMessage: 'No preview available for this track',
//         isPlaying: false,
//       );
//       return;
//     }

//     try {
//       if (state.currentTrackId != trackId) {
//         await state.audioPlayer.stop();
//         print('Playing URL: $previewUrl');
//         await state.audioPlayer.setUrl(previewUrl);
//         await state.audioPlayer.play();
//         state = state.copyWith(
//           currentTrackId: trackId,
//           errorMessage: null,
//           isPlaying: true,
//         );
//       } else if (!state.isPlaying) {
//         await state.audioPlayer.play();
//         state = state.copyWith(isPlaying: true, errorMessage: null);
//       }
//     } catch (e, stackTrace) {
//       print('Error playing track: $e\n$stackTrace');
//       state = state.copyWith(
//         isPlaying: false,
//         errorMessage: 'Failed to play track: $e',
//       );
//     }
//   }

//   /// Pauses the current track.
//   Future<void> pauseTrack() async {
//     try {
//       await state.audioPlayer.pause();
//       state = state.copyWith(isPlaying: false, errorMessage: null);
//     } catch (e) {
//       print('Error pausing track: $e');
//       state = state.copyWith(
//         isPlaying: false,
//         errorMessage: 'Failed to pause track: $e',
//       );
//     }
//   }

//   /// Toggles play/pause for the given track.
//   Future<void> togglePlayPause(String trackId, String? previewUrl) async {
//     if (state.currentTrackId == trackId && state.isPlaying) {
//       await pauseTrack();
//     } else {
//       await playTrack(trackId, previewUrl);
//     }
//   }

//   @override
//   void dispose() {
//     state.audioPlayer.dispose();
//     super.dispose();
//   }
// }

// /// Riverpod provider for audio playback.
// final audioPlayerProvider =
//     StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
//       (ref) => AudioPlayerNotifier(),
//     );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:developer';

class AudioPlayerState {
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final String? currentTrackId;
  final String? errorMessage;

  AudioPlayerState({
    required this.audioPlayer,
    this.isPlaying = false,
    this.currentTrackId,
    this.errorMessage,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    String? currentTrackId,
    String? errorMessage,
  }) {
    return AudioPlayerState(
      audioPlayer: audioPlayer,
      isPlaying: isPlaying ?? this.isPlaying,
      currentTrackId: currentTrackId ?? this.currentTrackId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(AudioPlayerState(audioPlayer: AudioPlayer()));

  Future<void> playTrack(String trackId, String? previewUrl) async {
    if (previewUrl == null || previewUrl.isEmpty) {
      log('No preview URL for track: $trackId');
      state = state.copyWith(
        errorMessage: 'No preview available for this track',
        isPlaying: false,
      );
      return;
    }

    try {
      if (state.currentTrackId != trackId) {
        await state.audioPlayer.stop();
        log('Playing URL: $previewUrl');
        await state.audioPlayer.setUrl(previewUrl);
        await state.audioPlayer.play();
        state = state.copyWith(
          currentTrackId: trackId,
          errorMessage: null,
          isPlaying: true,
        );
        log(
          'State updated: isPlaying=${state.isPlaying}, currentTrackId=${state.currentTrackId}',
        );
      } else if (!state.isPlaying) {
        await state.audioPlayer.play();
        state = state.copyWith(isPlaying: true, errorMessage: null);
        log('State updated: isPlaying=${state.isPlaying}');
      }
    } catch (e, stackTrace) {
      log('Error playing track: $e\n$stackTrace');
      state = state.copyWith(
        isPlaying: false,
        errorMessage: 'Failed to play track: $e',
      );
    }
  }

  Future<void> pauseTrack() async {
    try {
      await state.audioPlayer.pause();
      state = state.copyWith(isPlaying: false, errorMessage: null);
      log('State updated: isPlaying=${state.isPlaying}');
    } catch (e) {
      log('Error pausing track: $e');
      state = state.copyWith(
        isPlaying: false,
        errorMessage: 'Failed to pause track: $e',
      );
    }
  }

  Future<void> togglePlayPause(String trackId, String? previewUrl) async {
    log(
      'togglePlayPause: trackId=$trackId, isPlaying=${state.isPlaying}, currentTrackId=${state.currentTrackId}',
    );
    if (state.currentTrackId == trackId && state.isPlaying) {
      await pauseTrack();
    } else {
      await playTrack(trackId, previewUrl);
    }
  }

  @override
  void dispose() {
    state.audioPlayer.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
      (ref) => AudioPlayerNotifier(),
    );
