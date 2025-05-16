import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/appimages.dart';
import 'package:spotify_clone/models/editors_pick_model.dart';
import 'package:spotify_clone/providers/audioplayer_provider.dart';
import 'package:spotify_clone/providers/editors_pick_providers.dart';
import 'package:spotify_clone/screens/now_playing_bar.dart';
import 'package:spotify_clone/shared_utils.dart';

/// Displays detailed playlist information and allows track playback.
class EditorsPickPage extends ConsumerStatefulWidget {
  final String playlistId;

  const EditorsPickPage({super.key, required this.playlistId});

  @override
  _EditorsPickPageState createState() => _EditorsPickPageState();
}

class _EditorsPickPageState extends ConsumerState<EditorsPickPage> {
  @override
  void initState() {
    super.initState();
    _fetchPlaylistDetails();
  }

  /// Fetches playlist details using the provided token.
  Future<void> _fetchPlaylistDetails() async {
    final token = await SharedPreferencesUtil.getAuthToken();
    print('EditorsPickPage Token: $token');
    if (token != null) {
      ref
          .read(playlistDetailsProvider.notifier)
          .getPlaylistDetails(token, widget.playlistId);
    } else {
      ref.read(playlistDetailsProvider.notifier).state = PlaylistDetailsState(
        isLoading: false,
        errorMessage: 'No authentication token found',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to continue.'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  /// Displays an error message via SnackBar.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistDetailsProvider);
    final audioState = ref.watch(audioPlayerProvider);

    // Handle audio playback errors
    if (audioState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar(audioState.errorMessage!);
        ref.read(audioPlayerProvider.notifier).state = audioState.copyWith(
          errorMessage: null,
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Playlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const NowPlayingBar(),
      body: SafeArea(
        child:
            playlistState.isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
                : playlistState.errorMessage.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playlistState.errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchPlaylistDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                : playlistState.playlistDetails == null
                ? const Center(
                  child: Text(
                    'No playlist details available',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Playlist Image
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image:
                                  playlistState
                                          .playlistDetails!
                                          .images
                                          .isNotEmpty
                                      ? NetworkImage(
                                        playlistState
                                            .playlistDetails!
                                            .images[0]
                                            .url,
                                      )
                                      : const AssetImage(Appimages.allOut)
                                          as ImageProvider,
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print('Image load error: $exception');
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Playlist Name
                        Text(
                          playlistState.playlistDetails!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Playlist Owner
                        Text(
                          playlistState.playlistDetails!.owner.displayName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Tracks List
                        playlistState.playlistDetails!.tracks.items.isEmpty
                            ? const Center(
                              child: Text(
                                'No tracks available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  playlistState
                                      .playlistDetails!
                                      .tracks
                                      .items
                                      .length,
                              itemBuilder: (context, index) {
                                final track =
                                    playlistState
                                        .playlistDetails!
                                        .tracks
                                        .items[index]
                                        .track;
                                final duration = Duration(
                                  milliseconds: track.durationMs,
                                );
                                final minutes = duration.inMinutes;
                                final seconds = (duration.inSeconds % 60)
                                    .toString()
                                    .padLeft(2, '0');
                                final isPlaying =
                                    audioState.isPlaying &&
                                    audioState.currentTrack?.id ==
                                        track.id; // Fixed comparison

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: GestureDetector(
                                    onTap:
                                        track.previewUrl != null
                                            ? () {
                                              print(
                                                'Playing track: ${track.name}, '
                                                'Preview URL: ${track.previewUrl}',
                                              );
                                              ref
                                                  .read(
                                                    audioPlayerProvider
                                                        .notifier,
                                                  )
                                                  .togglePlayPause(
                                                    track,
                                                  ); // Fixed to pass Track object
                                            }
                                            : null,
                                    child: Row(
                                      children: [
                                        // Play/Pause/Lock Icon
                                        Icon(
                                          track.previewUrl != null
                                              ? (isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_filled)
                                              : Icons.lock,
                                          color:
                                              track.previewUrl != null
                                                  ? Colors.green
                                                  : Colors.grey,
                                          size: 40,
                                        ),
                                        const SizedBox(width: 12),
                                        // Track Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                track.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                track.artists
                                                    .map(
                                                      (artist) => artist.name,
                                                    )
                                                    .join(', '),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Track Duration
                                        Text(
                                          '$minutes:$seconds',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
