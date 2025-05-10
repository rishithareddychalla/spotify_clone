import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spotify_clone/providers/releases.dart';
import 'package:spotify_clone/screens/login_page.dart';
import 'package:spotify_clone/shared_utils.dart';

class NewReleasesPage extends ConsumerStatefulWidget {
  final String albumId;
  const NewReleasesPage({super.key, required this.albumId});

  @override
  _NewReleasesPageState createState() => _NewReleasesPageState();
}

class _NewReleasesPageState extends ConsumerState<NewReleasesPage> {
  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
  }

  Future<void> _fetchAlbumDetails() async {
    final token = await SharedPreferencesUtil.getAuthToken();
    if (token != null) {
      await ref
          .read(albumDetailsProvider.notifier)
          .getAlbumDetails(token, widget.albumId);
      final albumDetailsState = ref.read(albumDetailsProvider);
      if (albumDetailsState.errorMessage.contains('401')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } else {
      ref.read(albumDetailsProvider.notifier).state = AlbumDetailsState(
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
    final albumDetailsState = ref.watch(albumDetailsProvider);

    log(
      'NewReleasesPage State - isLoading: ${albumDetailsState.isLoading}, errorMessage: ${albumDetailsState.errorMessage}, albumDetails: ${albumDetailsState.albumDetails}',
    );

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
          albumDetailsState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : albumDetailsState.errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      albumDetailsState.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: _fetchAlbumDetails,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : albumDetailsState.albumDetails == null
              ? const Center(
                child: Text(
                  "No album details available",
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              albumDetailsState.albumDetails!.images.isNotEmpty
                                  ? albumDetailsState
                                      .albumDetails!
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
                      const SizedBox(height: 16),
                      Text(
                        albumDetailsState.albumDetails!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        albumDetailsState.albumDetails!.artists
                            .map((artist) => artist.name)
                            .join(', '),
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
                            albumDetailsState.albumDetails!.tracks.items.length,
                        itemBuilder: (context, index) {
                          final track =
                              albumDetailsState
                                  .albumDetails!
                                  .tracks
                                  .items[index];
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
