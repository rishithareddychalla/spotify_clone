import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/providers/editors_pick_providers.dart';
import 'package:spotify_clone/shared_utils.dart';

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

  Future<void> _fetchPlaylistDetails() async {
    final token = await SharedPreferencesUtil.getAuthToken();
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

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistDetailsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
      body:
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
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: _fetchPlaylistDetails,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : playlistState.playlistDetails == null
              ? const Center(
                child: Text(
                  "No playlist details available",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    playlistState
                                            .playlistDetails!
                                            .images
                                            .isNotEmpty
                                        ? playlistState
                                            .playlistDetails!
                                            .images[0]
                                            .url
                                        : '',
                                  ),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    print('Image load error: $exception');
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        playlistState.playlistDetails!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        playlistState.playlistDetails!.owner.displayName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            playlistState.playlistDetails!.tracks.items.length,
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
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
                                            .map((artist) => artist.name)
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
                                Text(
                                  '$minutes:$seconds',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
