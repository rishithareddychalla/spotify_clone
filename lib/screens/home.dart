import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/appimages.dart';
import 'package:spotify_clone/models/featured_playlists_model.dart';
import 'package:spotify_clone/models/categories_model.dart' as CategoriesModel;
import 'package:spotify_clone/models/new_releases_model.dart' as AlbumsModel;
import 'package:spotify_clone/providers/categories_provider.dart';
import 'package:spotify_clone/providers/featured_playlist_providers.dart';
import 'package:spotify_clone/providers/login_provider.dart';
import 'package:spotify_clone/providers/new_releases_provider.dart';
import 'package:spotify_clone/screens/editorspicscreen.dart.dart';
import 'package:spotify_clone/screens/loader.dart';
import 'package:spotify_clone/screens/login_page.dart';
import 'package:spotify_clone/screens/newreleases.dart';
import 'package:spotify_clone/screens/genrescreen.dart';
import 'package:spotify_clone/shared_utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? authToken;
  bool _isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isFetchingData = true;
    });

    final token = await SharedPreferencesUtil.getAuthToken();
    if (token != null) {
      setState(() {
        authToken = token;
      });
      log('HomePage Token: $token');
      try {
        await Future.wait([
          ref.read(featuredProvider.notifier).getFeatured(token),
          ref.read(categoriesProvider.notifier).getCategories(token),
          ref.read(albumsProvider.notifier).getAlbums(token),
        ]);
      } catch (e) {
        log('Error fetching data: $e');
        setState(() {
          _isFetchingData = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please log in again.'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return;
      }
    } else {
      log('No token found in HomePage');
      setState(() {
        _isFetchingData = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to continue.'),
            backgroundColor: Colors.red,
          ),
        );
      });
      return;
    }

    setState(() {
      _isFetchingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    final FeaturedState featuredState = ref.watch(featuredProvider);
    final CategoriesState categoriesState = ref.watch(categoriesProvider);
    final AlbumsState albumsState = ref.watch(albumsProvider);

    log('FeaturedState: $featuredState');
    log('CategoriesState: $categoriesState');
    log('AlbumsState: $albumsState');

    if (_isFetchingData || authToken == null) {
      return const LoadingScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Row(
          children: [
            Icon(Icons.equalizer, color: Colors.green, size: 30),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await ref.read(loginProvider.notifier).logout();
              context.go('/login');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Editor's picks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: screensize.height * 0.5,
                child:
                    featuredState.isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                        : featuredState.errorMessage.isNotEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                featuredState.errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: _fetchData,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                        : featuredState.featured.isEmpty
                        ? const Center(
                          child: Text(
                            "No playlists available",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                          itemCount:
                              featuredState.featured.length > 9
                                  ? 9
                                  : featuredState.featured.length,
                          itemBuilder: (context, index) {
                            final Item playlist = featuredState.featured[index];
                            final String imageUrl =
                                playlist.images.isNotEmpty
                                    ? playlist.images[0].url
                                    : '';
                            return GestureDetector(
                              onTap: () {
                                if (authToken != null) {
                                  log(
                                    'Navigating to EditorsPickPage with token: $authToken, playlistId: ${playlist.id}',
                                  );
                                  context.go(
                                    '/editors-pick/${playlist.id}?token=$authToken',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Authentication token not found',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image:
                                            imageUrl.isNotEmpty
                                                ? NetworkImage(imageUrl)
                                                : const AssetImage(
                                                      Appimages.allOut,
                                                    )
                                                    as ImageProvider,
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          print('Image load error: $exception');
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    playlist.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    playlist.owner.displayName.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Genres & Moods",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: screensize.height * 0.25,
                child:
                    categoriesState.isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                        : categoriesState.errorMessage.isNotEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: ${categoriesState.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: _fetchData,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                        : categoriesState.categories.isEmpty
                        ? const Center(
                          child: Text(
                            "No categories available",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.6,
                              ),
                          itemCount:
                              categoriesState.categories.length > 9
                                  ? 9
                                  : categoriesState.categories.length,
                          itemBuilder: (context, index) {
                            final CategoriesModel.Item category =
                                categoriesState.categories[index];
                            final String imageUrl =
                                (category.icons != null &&
                                        category.icons!.isNotEmpty)
                                    ? category.icons![0].url
                                    : '';
                            return GestureDetector(
                              onTap: () {
                                if (authToken != null) {
                                  log(
                                    'Navigating to GenrePage with token: $authToken, categoryId: ${category.id}',
                                  );
                                  context.go(
                                    '/genre/${category.id}?token=$authToken',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Authentication token not found',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 70,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color:
                                            imageUrl.isEmpty
                                                ? Colors.grey
                                                : null,
                                        image:
                                            imageUrl.isNotEmpty
                                                ? DecorationImage(
                                                  image: NetworkImage(imageUrl),
                                                  fit: BoxFit.cover,
                                                  onError: (
                                                    exception,
                                                    stackTrace,
                                                  ) {
                                                    print(
                                                      'Category image load error: $exception',
                                                    );
                                                  },
                                                )
                                                : null,
                                      ),
                                      child:
                                          imageUrl.isEmpty
                                              ? Center(
                                                child: Text(
                                                  category.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              const SizedBox(height: 30),
              const Text(
                "New releases",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: screensize.height * 0.5,
                child:
                    albumsState.isLoading
                        ? const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                        : albumsState.errorMessage.isNotEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: ${albumsState.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: _fetchData,
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                        : albumsState.albums.isEmpty
                        ? const Center(
                          child: Text(
                            "No albums available",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                          itemCount:
                              albumsState.albums.length > 9
                                  ? 9
                                  : albumsState.albums.length,
                          itemBuilder: (context, index) {
                            final AlbumsModel.Item album =
                                albumsState.albums[index];
                            final String imageUrl =
                                album.images.isNotEmpty
                                    ? album.images[0].url
                                    : '';
                            return GestureDetector(
                              onTap: () {
                                if (authToken != null) {
                                  log(
                                    'Navigating to NewReleasesPage with token: $authToken, albumId: ${album.id}',
                                  );
                                  context.go(
                                    '/new-releases/${album.id}?token=$authToken',
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Authentication token not found',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          imageUrl.isEmpty ? Colors.grey : null,
                                      image:
                                          imageUrl.isNotEmpty
                                              ? DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.fitHeight,

                                                onError: (
                                                  exception,
                                                  stackTrace,
                                                ) {
                                                  print(
                                                    'Album image load error: $exception',
                                                  );
                                                },
                                              )
                                              : null,
                                    ),
                                    child:
                                        imageUrl.isEmpty
                                            ? Center(
                                              child: Text(
                                                album.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                            : null,
                                  ),
                                  Text(
                                    album.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,

                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    album.artists.isNotEmpty
                                        ? album.artists[0].name
                                        : 'Unknown Artist',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
