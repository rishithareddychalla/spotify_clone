class CategoryPlaylists {
  final Playlists playlists;

  CategoryPlaylists({required this.playlists});

  factory CategoryPlaylists.fromJson(Map<String, dynamic> json) {
    return CategoryPlaylists(
      playlists: Playlists.fromJson(json['playlists'] ?? {}),
    );
  }
}

class Playlists {
  final List<PlaylistItem> items;

  Playlists({required this.items});

  factory Playlists.fromJson(Map<String, dynamic> json) {
    return Playlists(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => PlaylistItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PlaylistItem {
  final String id;
  final String name;
  final List<Image> images;
  final Owner owner;

  PlaylistItem({
    required this.id,
    required this.name,
    required this.images,
    required this.owner,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    return PlaylistItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => Image.fromJson(image))
              .toList() ??
          [],
      owner: Owner.fromJson(json['owner'] ?? {}),
    );
  }
}

class Image {
  final String url;

  Image({required this.url});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(url: json['url'] ?? '');
  }
}

class Owner {
  final String displayName;

  Owner({required this.displayName});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(displayName: json['display_name'] ?? '');
  }
}
