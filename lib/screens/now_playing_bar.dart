import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_clone/providers/audioplayer_provider.dart';

/// Fixed bottom bar displaying the currently playing track and play/pause controls.
class NowPlayingBar extends ConsumerWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);

    // Hide the bar if no track is selected
    if (audioState.currentTrack == null) {
      return const SizedBox.shrink();
    }

    final track = audioState.currentTrack!;
    final isPlaying = audioState.isPlaying;

    // Get position and duration streams
    final positionStream = audioState.audioPlayer.positionStream;
    final durationStream = audioState.audioPlayer.durationStream;

    return Container(
      height: 64,
      color: const Color(0xFF282828),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black54, width: 1.0)),
      ),
      child: Column(
        children: [
          // Progress Bar
          StreamBuilder<Duration>(
            stream: positionStream,
            builder: (context, positionSnapshot) {
              final position = positionSnapshot.data ?? Duration.zero;
              return StreamBuilder<Duration?>(
                stream: durationStream,
                builder: (context, durationSnapshot) {
                  final duration = durationSnapshot.data ?? Duration.zero;
                  final progress =
                      duration.inSeconds > 0
                          ? position.inSeconds / duration.inSeconds
                          : 0.0;
                  return LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[700],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 2,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 4),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Album Art (Placeholder if not available)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[800],
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Track Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        track.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artists.map((artist) => artist.name).join(', '),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Play/Pause Button
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () {
                    print(
                      'Toggling track: ${track.name}, '
                      'Preview URL: ${track.previewUrl}',
                    );
                    ref
                        .read(audioPlayerProvider.notifier)
                        .togglePlayPause(track);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
