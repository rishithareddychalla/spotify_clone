class AlbumDetails {
  final String id;
  final String name;
  final List<Artist> artists;
  final List<Image> images;
  final Tracks tracks;

  AlbumDetails({
    required this.id,
    required this.name,
    required this.artists,
    required this.images,
    required this.tracks,
  });

  factory AlbumDetails.fromJson(Map<String, dynamic> json) {
    return AlbumDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map((artist) => Artist.fromJson(artist))
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => Image.fromJson(image))
              .toList() ??
          [],
      tracks: Tracks.fromJson(json['tracks'] ?? {}),
    );
  }
}

class Artist {
  final String name;

  Artist({required this.name});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(name: json['name'] ?? '');
  }
}

class Image {
  final String url;

  Image({required this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(url: json['url'] ?? '');
  }
}

class Tracks {
  final List<TrackItem> items;

  Tracks({required this.items});

  factory Tracks.fromJson(Map<String, dynamic> json) {
    return Tracks(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => TrackItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TrackItem {
  final String id;
  final String name;
  final List<Artist> artists;
  final int durationMs;

  TrackItem({
    required this.id,
    required this.name,
    required this.artists,
    required this.durationMs,
  });

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    return TrackItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map((artist) => Artist.fromJson(artist))
              .toList() ??
          [],
      durationMs: json['duration_ms'] ?? 0,
    );
  }
}
