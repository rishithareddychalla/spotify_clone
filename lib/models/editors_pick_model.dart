class PlaylistDetails {
  final String id;
  final String name;
  final Owner owner;
  final List<Image> images;
  final Tracks tracks;

  PlaylistDetails({
    required this.id,
    required this.name,
    required this.owner,
    required this.images,
    required this.tracks,
  });

  factory PlaylistDetails.fromJson(Map<String, dynamic> json) {
    return PlaylistDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      owner: Owner.fromJson(json['owner'] ?? {}),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => Image.fromJson(image))
              .toList() ??
          [],
      tracks: Tracks.fromJson(json['tracks'] ?? {}),
    );
  }
}

class Owner {
  final String displayName;

  Owner({required this.displayName});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(displayName: json['display_name'] ?? '');
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
  final Track track;

  TrackItem({required this.track});

  factory TrackItem.fromJson(Map<String, dynamic> json) {
    return TrackItem(track: Track.fromJson(json['track'] ?? {}));
  }
}

class Track {
  final String id;
  final String name;
  final List<Artist> artists;
  final int durationMs;

  Track({
    required this.id,
    required this.name,
    required this.artists,
    required this.durationMs,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
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

class Artist {
  final String name;

  Artist({required this.name});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(name: json['name'] ?? '');
  }
}
