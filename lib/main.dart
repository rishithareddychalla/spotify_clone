import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify_clone/screens/editorspicscreen.dart.dart';
import 'package:spotify_clone/screens/home.dart';
import 'package:spotify_clone/screens/genrescreen.dart';
import 'package:spotify_clone/screens/homeerror.dart';
import 'package:spotify_clone/screens/login_page.dart';
import 'package:spotify_clone/screens/newreleases.dart';
import 'package:spotify_clone/providers/login_provider.dart';
import 'package:spotify_clone/shared_utils.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/editors-pick/:playlistId',
          builder: (context, state) {
            final playlistId = state.pathParameters['playlistId']!;
            final token = ref.read(loginProvider).token ?? '';
            return EditorsPickPage(playlistId: playlistId);
          },
        ),
        GoRoute(
          path: '/genre/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            final token = ref.read(loginProvider).token ?? '';
            return GenrePage(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: '/new-releases/:albumId',
          builder: (context, state) {
            final albumId = state.pathParameters['albumId']!;
            final token = ref.read(loginProvider).token ?? '';
            return NewReleasesPage(albumId: albumId);
          },
        ),
        GoRoute(
          path: '/error',
          builder: (context, state) {
            final token = ref.read(loginProvider).token ?? '';
            return NotFoundPage();
          },
        ),
      ],
      redirect: (context, state) async {
        final token = await SharedPreferencesUtil.getAuthToken();
        final loginState = ref.read(loginProvider);
        final isLoggedIn =
            token != null && token.isNotEmpty && loginState.token != null;

        if (!isLoggedIn && state.matchedLocation != '/login') {
          return '/login';
        }

        if (isLoggedIn && state.matchedLocation == '/login') {
          return '/';
        }
        return null;
      },
    );

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
