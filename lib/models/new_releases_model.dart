import 'package:meta/meta.dart';
import 'dart:convert';

class Releases {
  final Albums albums;

  Releases({required this.albums});

  Releases copyWith({Albums? albums}) =>
      Releases(albums: albums ?? this.albums);

  factory Releases.fromRawJson(String str) =>
      Releases.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Releases.fromJson(Map<String, dynamic> json) =>
      Releases(albums: Albums.fromJson(json["albums"]));

  Map<String, dynamic> toJson() => {"albums": albums.toJson()};
}

class Albums {
  final String href;
  final List<Item> items;
  final int limit;
  final String next;
  final int offset;
  final dynamic previous;
  final int total;

  Albums({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
  });

  Albums copyWith({
    String? href,
    List<Item>? items,
    int? limit,
    String? next,
    int? offset,
    dynamic previous,
    int? total,
  }) => Albums(
    href: href ?? this.href,
    items: items ?? this.items,
    limit: limit ?? this.limit,
    next: next ?? this.next,
    offset: offset ?? this.offset,
    previous: previous ?? this.previous,
    total: total ?? this.total,
  );

  factory Albums.fromRawJson(String str) => Albums.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Albums.fromJson(Map<String, dynamic> json) => Albums(
    href: json["href"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    limit: json["limit"],
    next: json["next"],
    offset: json["offset"],
    previous: json["previous"],
    total: json["total"],
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
  final AlbumTypeEnum albumType;
  final List<Artist> artists;
  final List<String> availableMarkets;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final List<Image> images;
  final String name;
  final DateTime releaseDate;
  final ReleaseDatePrecision releaseDatePrecision;
  final int totalTracks;
  final AlbumTypeEnum type;
  final String uri;

  Item({
    required this.albumType,
    required this.artists,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.type,
    required this.uri,
  });

  Item copyWith({
    AlbumTypeEnum? albumType,
    List<Artist>? artists,
    List<String>? availableMarkets,
    ExternalUrls? externalUrls,
    String? href,
    String? id,
    List<Image>? images,
    String? name,
    DateTime? releaseDate,
    ReleaseDatePrecision? releaseDatePrecision,
    int? totalTracks,
    AlbumTypeEnum? type,
    String? uri,
  }) => Item(
    albumType: albumType ?? this.albumType,
    artists: artists ?? this.artists,
    availableMarkets: availableMarkets ?? this.availableMarkets,
    externalUrls: externalUrls ?? this.externalUrls,
    href: href ?? this.href,
    id: id ?? this.id,
    images: images ?? this.images,
    name: name ?? this.name,
    releaseDate: releaseDate ?? this.releaseDate,
    releaseDatePrecision: releaseDatePrecision ?? this.releaseDatePrecision,
    totalTracks: totalTracks ?? this.totalTracks,
    type: type ?? this.type,
    uri: uri ?? this.uri,
  );

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    albumType: albumTypeEnumValues.map[json["album_type"]]!,
    artists: List<Artist>.from(json["artists"].map((x) => Artist.fromJson(x))),
    availableMarkets: List<String>.from(
      json["available_markets"].map((x) => x),
    ),
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    name: json["name"],
    releaseDate: DateTime.parse(json["release_date"]),
    releaseDatePrecision:
        releaseDatePrecisionValues.map[json["release_date_precision"]]!,
    totalTracks: json["total_tracks"],
    type: albumTypeEnumValues.map[json["type"]]!,
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "album_type": albumTypeEnumValues.reverse[albumType],
    "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
    "available_markets": List<dynamic>.from(availableMarkets.map((x) => x)),
    "external_urls": externalUrls.toJson(),
    "href": href,
    "id": id,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "name": name,
    "release_date":
        "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "release_date_precision":
        releaseDatePrecisionValues.reverse[releaseDatePrecision],
    "total_tracks": totalTracks,
    "type": albumTypeEnumValues.reverse[type],
    "uri": uri,
  };
}

enum AlbumTypeEnum { ALBUM, SINGLE }

final albumTypeEnumValues = EnumValues({
  "album": AlbumTypeEnum.ALBUM,
  "single": AlbumTypeEnum.SINGLE,
});

class Artist {
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final String name;
  final ArtistType type;
  final String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  Artist copyWith({
    ExternalUrls? externalUrls,
    String? href,
    String? id,
    String? name,
    ArtistType? type,
    String? uri,
  }) => Artist(
    externalUrls: externalUrls ?? this.externalUrls,
    href: href ?? this.href,
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    uri: uri ?? this.uri,
  );

  factory Artist.fromRawJson(String str) => Artist.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    externalUrls: ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    name: json["name"],
    type: artistTypeValues.map[json["type"]]!,
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "external_urls": externalUrls.toJson(),
    "href": href,
    "id": id,
    "name": name,
    "type": artistTypeValues.reverse[type],
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
      ExternalUrls(spotify: json["spotify"]);

  Map<String, dynamic> toJson() => {"spotify": spotify};
}

enum ArtistType { ARTIST }

final artistTypeValues = EnumValues({"artist": ArtistType.ARTIST});

class Image {
  final int height;
  final String url;
  final int width;

  Image({required this.height, required this.url, required this.width});

  Image copyWith({int? height, String? url, int? width}) => Image(
    height: height ?? this.height,
    url: url ?? this.url,
    width: width ?? this.width,
  );

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(height: json["height"], url: json["url"], width: json["width"]);

  Map<String, dynamic> toJson() => {
    "height": height,
    "url": url,
    "width": width,
  };
}

enum ReleaseDatePrecision { DAY }

final releaseDatePrecisionValues = EnumValues({
  "day": ReleaseDatePrecision.DAY,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
