import 'package:meta/meta.dart';
import 'dart:convert';

class Featured {
  final String message;
  final Playlists playlists;

  Featured({required this.message, required this.playlists});

  Featured copyWith({String? message, Playlists? playlists}) => Featured(
    message: message ?? this.message,
    playlists: playlists ?? this.playlists,
  );

  factory Featured.fromRawJson(String str) =>
      Featured.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Featured.fromJson(Map<String, dynamic> json) => Featured(
    message: json["message"] ?? "",
    playlists: Playlists.fromJson(json["playlists"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "playlists": playlists.toJson(),
  };
}

class Playlists {
  final String href;
  final List<Item> items;
  final int limit;
  final String next;
  final int offset;
  final dynamic previous;
  final int total;

  Playlists({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  Playlists copyWith({
    String? href,
    List<Item>? items,
    int? limit,
    String? next,
    int? offset,
    dynamic previous,
    int? total,
  }) => Playlists(
    href: href ?? this.href,
    items: items ?? this.items,
    limit: limit ?? this.limit,
    next: next ?? this.next,
    offset: offset ?? this.offset,
    previous: previous ?? this.previous,
    total: total ?? this.total,
  );

  factory Playlists.fromRawJson(String str) =>
      Playlists.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Playlists.fromJson(Map<String, dynamic> json) => Playlists(
    href: json["href"] ?? "",
    items:
        json["items"] != null
            ? List<Item>.from(json["items"].map((x) => Item.fromJson(x)))
            : [],
    limit: json["limit"] ?? 0,
    next: json["next"] ?? "",
    offset: json["offset"] ?? 0,
    previous: json["previous"],
    total: json["total"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "limit": limit,
    "next": next,
    "offset": offset,
    "previous": previous,
    "total": total,
  };
}

class Item {
  final bool collaborative;
  final String description;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final List<Image> images;
  final String name;
  final Owner owner;
  final dynamic primaryColor;
  final dynamic public;
  final String snapshotId;
  final Tracks tracks;
  final ItemType type;
  final String uri;

  Item({
    required this.collaborative,
    required this.description,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.primaryColor,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  Item copyWith({
    bool? collaborative,
    String? description,
    ExternalUrls? externalUrls,
    String? href,
    String? id,
    List<Image>? images,
    String? name,
    Owner? owner,
    dynamic primaryColor,
    dynamic public,
    String? snapshotId,
    Tracks? tracks,
    ItemType? type,
    String? uri,
  }) => Item(
    collaborative: collaborative ?? this.collaborative,
    description: description ?? this.description,
    externalUrls: externalUrls ?? this.externalUrls,
    href: href ?? this.href,
    id: id ?? this.id,
    images: images ?? this.images,
    name: name ?? this.name,
    owner: owner ?? this.owner,
    primaryColor: primaryColor ?? this.primaryColor,
    public: public ?? this.public,
    snapshotId: snapshotId ?? this.snapshotId,
    tracks: tracks ?? this.tracks,
    type: type ?? this.type,
    uri: uri ?? this.uri,
  );

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    collaborative: json["collaborative"] ?? false,
    description: json["description"] ?? "",
    externalUrls: ExternalUrls.fromJson(json["external_urls"] ?? {}),
    href: json["href"] ?? "",
    id: json["id"] ?? "",
    images:
        json["images"] != null
            ? List<Image>.from(json["images"].map((x) => Image.fromJson(x)))
            : [],
    name: json["name"] ?? "",
    owner: Owner.fromJson(json["owner"] ?? {}),
    primaryColor: json["primary_color"],
    public: json["public"],
    snapshotId: json["snapshot_id"] ?? "",
    tracks: Tracks.fromJson(json["tracks"] ?? {}),
    type: itemTypeValues.map[json["type"]] ?? ItemType.PLAYLIST,
    uri: json["uri"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "collaborative": collaborative,
    "description": description,
    "external_urls": externalUrls.toJson(),
    "href": href,
    "id": id,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "name": name,
    "owner": owner.toJson(),
    "primary_color": primaryColor,
    "public": public,
    "snapshot_id": snapshotId,
    "tracks": tracks.toJson(),
    "type": itemTypeValues.reverse[type],
    "uri": uri,
  };
}

class ExternalUrls {
  final String spotify;

  ExternalUrls({required this.spotify});

  ExternalUrls copyWith({String? spotify}) =>
      ExternalUrls(spotify: spotify ?? this.spotify);

  factory ExternalUrls.fromRawJson(String str) =>
      ExternalUrls.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      ExternalUrls(spotify: json["spotify"] ?? "");

  Map<String, dynamic> toJson() => {"spotify": spotify};
}

class Image {
  final dynamic height;
  final String url;
  final dynamic width;

  Image({required this.height, required this.url, required this.width});

  Image copyWith({dynamic height, String? url, dynamic width}) => Image(
    height: height ?? this.height,
    url: url ?? this.url,
    width: width ?? this.width,
  );

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    height: json["height"],
    url: json["url"] ?? "",
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "url": url,
    "width": width,
  };
}

class Owner {
  final DisplayName displayName;
  final ExternalUrls externalUrls;
  final String href;
  final Id id;
  final OwnerType type;
  final OwnerUri uri;

  Owner({
    required this.displayName,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  Owner copyWith({
    DisplayName? displayName,
    ExternalUrls? externalUrls,
    String? href,
    Id? id,
    OwnerType? type,
    OwnerUri? uri,
  }) => Owner(
    displayName: displayName ?? this.displayName,
    externalUrls: externalUrls ?? this.externalUrls,
    href: href ?? this.href,
    id: id ?? this.id,
    type: type ?? this.type,
    uri: uri ?? this.uri,
  );

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    displayName:
        displayNameValues.map[json["display_name"]] ?? DisplayName.SPOTIFY,
    externalUrls: ExternalUrls.fromJson(json["external_urls"] ?? {}),
    href: json["href"] ?? "",
    id: idValues.map[json["id"]] ?? Id.SPOTIFY,
    type: ownerTypeValues.map[json["type"]] ?? OwnerType.USER,
    uri: ownerUriValues.map[json["uri"]] ?? OwnerUri.SPOTIFY_USER_SPOTIFY,
  );

  Map<String, dynamic> toJson() => {
    "display_name": displayNameValues.reverse[displayName],
    "external_urls": externalUrls.toJson(),
    "href": href,
    "id": idValues.reverse[id],
    "type": ownerTypeValues.reverse[type],
    "uri": ownerUriValues.reverse[uri],
  };
}

enum DisplayName { SPOTIFY }

final displayNameValues = EnumValues({"Spotify": DisplayName.SPOTIFY});

enum Id { SPOTIFY }

final idValues = EnumValues({"spotify": Id.SPOTIFY});

enum OwnerType { USER }

final ownerTypeValues = EnumValues({"user": OwnerType.USER});

enum OwnerUri { SPOTIFY_USER_SPOTIFY }

final ownerUriValues = EnumValues({
  "spotify:user:spotify": OwnerUri.SPOTIFY_USER_SPOTIFY,
});

class Tracks {
  final String href;
  final int total;

  Tracks({required this.href, required this.total});

  Tracks copyWith({String? href, int? total}) =>
      Tracks(href: href ?? this.href, total: total ?? this.total);

  factory Tracks.fromRawJson(String str) => Tracks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tracks.fromJson(Map<String, dynamic> json) =>
      Tracks(href: json["href"] ?? "", total: json["total"] ?? 0);

  Map<String, dynamic> toJson() => {"href": href, "total": total};
}

enum ItemType { PLAYLIST }

final itemTypeValues = EnumValues({"playlist": ItemType.PLAYLIST});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
