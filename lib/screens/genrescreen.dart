import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:spotify_clone/providers/genre_provider.dart';
import 'package:spotify_clone/screens/login_page.dart';
import 'package:spotify_clone/shared_utils.dart';

class GenrePage extends ConsumerStatefulWidget {
  final String categoryId;
  const GenrePage({super.key, required this.categoryId});

  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends ConsumerState<GenrePage> {
  @override
  void initState() {
    super.initState();
    _fetchCategoryPlaylists();
  }

  Future<void> _fetchCategoryPlaylists() async {
    final token = await SharedPreferencesUtil.getAuthToken();
    if (token != null) {
      await ref
          .read(categoryPlaylistsProvider.notifier)
          .getCategoryPlaylists(token, widget.categoryId);
      final categoryPlaylistsState = ref.read(categoryPlaylistsProvider);
      if (categoryPlaylistsState.errorMessage.contains('401')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } else {
      ref
          .read(categoryPlaylistsProvider.notifier)
          .state = CategoryPlaylistsState(
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
    final categoryPlaylistsState = ref.watch(categoryPlaylistsProvider);

    log(
      'GenrePage State - isLoading: ${categoryPlaylistsState.isLoading}, errorMessage: ${categoryPlaylistsState.errorMessage}, categoryPlaylists: ${categoryPlaylistsState.categoryPlaylists}',
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
          categoryPlaylistsState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : categoryPlaylistsState.errorMessage.isNotEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryPlaylistsState.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: _fetchCategoryPlaylists,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : categoryPlaylistsState.categoryPlaylists.isEmpty
              ? const Center(
                child: Text(
                  "No playlists available for this category",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: categoryPlaylistsState.categoryPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist =
                      categoryPlaylistsState.categoryPlaylists[index];
                  final imageUrl =
                      playlist.images.isNotEmpty ? playlist.images[0].url : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image:
                                imageUrl.isNotEmpty
                                    ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) {
                                        print('Image load error: $exception');
                                      },
                                    )
                                    : null,
                            color: imageUrl.isEmpty ? Colors.grey : null,
                          ),
                          child:
                              imageUrl.isEmpty
                                  ? Center(
                                    child: Text(
                                      playlist.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            playlist.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
