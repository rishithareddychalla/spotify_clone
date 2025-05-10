import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_clone/models/featured_playlists_model.dart';
import 'package:spotify_clone/shared_utils.dart';

class ApiService {
  static const String baseUrl = 'https://apis2.ccbp.in/spotify-clone';
  static const String loginUrl = 'https://apis.ccbp.in/login';

  Future<String> login(String username, String password) async {
    try {
      final url = Uri.parse(loginUrl);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'username': username, 'password': password});

      final response = await http.post(url, headers: headers, body: body);

      log('Login Status: ${response.statusCode}');
      log('Login Response: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['jwt_token'];
        await SharedPreferencesUtil.saveAuthToken(token);

        if (token != null) {
          log('Login is successful. Token: $token');
          return token;
        } else {
          throw Exception('Token not found');
        }
      } else {
        throw Exception(data['error_msg'] ?? 'Login failed');
      }
    } catch (e) {
      log('Login error: $e');
      throw Exception(e.toString().replaceFirst('Exception:', ''));
    }
  }

  Future<Map<String, dynamic>> fetchFeaturedPlaylists(String token) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/featured-playlists'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch featured playlists timed out');
            },
          );
      log('Fetch Featured Playlists Status: ${response.statusCode}');
      log('Fetch Featured Playlists Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'status': 200, 'body': data};
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'status': response.statusCode, 'body': errorData};
      }
    } catch (e) {
      log('Fetch Featured Playlists Error: $e');
      throw Exception('Failed to fetch featured playlists: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCategories(String token) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/categories'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch categories timed out');
            },
          );
      log('Fetch Categories Status: ${response.statusCode}');
      log('Fetch Categories Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'status': 200, 'body': data};
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'status': response.statusCode, 'body': errorData};
      }
    } catch (e) {
      log('Fetch Categories Error: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<Map<String, dynamic>> fetchNewReleases(String token) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/new-releases'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch new releases timed out');
            },
          );

      log('Fetch New Releases Status: ${response.statusCode}');
      log('Fetch New Releases Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'status': 200, 'body': data};
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return {'status': response.statusCode, 'body': errorData};
      }
    } catch (e) {
      log('Unexpected error in fetchNewReleases: $e');
      throw Exception('Failed to fetch new releases: $e');
    }
  }

  Future<Map<String, dynamic>> fetchPlaylistDetails(
    String playlistId,
    String token,
  ) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/playlists-details/$playlistId'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch playlist details timed out');
            },
          );
      log('Fetch Playlist Details Status: ${response.statusCode}');
      log('Fetch Playlist Details Response: ${response.body}');
      if (response.statusCode == 200) {
        return {'status': 200, 'body': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Failed to fetch playlist details: ${response.statusCode} - ${errorData['error_msg'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Unexpected error in fetchPlaylistDetails: $e');
      throw Exception('Failed to fetch playlist details: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCategoryPlaylists(
    String categoryId,
    String token,
  ) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/category-playlists/$categoryId'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch category playlists timed out');
            },
          );
      log('Fetch Category Playlists Status: ${response.statusCode}');
      log('Fetch Category Playlists Response: ${response.body}');
      if (response.statusCode == 200) {
        return {'status': 200, 'body': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Failed to fetch category playlists: ${response.statusCode} - ${errorData['error_msg'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Unexpected error in fetchCategoryPlaylists: $e');
      throw Exception('Failed to fetch category playlists: $e');
    }
  }

  Future<Map<String, dynamic>> fetchAlbumDetails(
    String albumId,
    String token,
  ) async {
    if (token.isEmpty) {
      throw Exception('No token provided');
    }

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/album-details/$albumId'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request to fetch album details timed out');
            },
          );
      log('Fetch Album Details Status: ${response.statusCode}');
      log('Fetch Album Details Response: ${response.body}');
      if (response.statusCode == 200) {
        return {'status': 200, 'body': jsonDecode(response.body)};
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Failed to fetch album details: ${response.statusCode} - ${errorData['error_msg'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Unexpected error in fetchAlbumDetails: $e');
      throw Exception('Failed to fetch album details: $e');
    }
  }
}
