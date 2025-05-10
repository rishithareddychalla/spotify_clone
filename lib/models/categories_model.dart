import 'package:meta/meta.dart';
import 'dart:convert';

class Categories {
  final CategoriesClass categories;

  Categories({required this.categories});

  Categories copyWith({CategoriesClass? categories}) =>
      Categories(categories: categories ?? this.categories);

  factory Categories.fromRawJson(String str) =>
      Categories.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    categories: CategoriesClass.fromJson(json["categories"] ?? {}),
  );

  Map<String, dynamic> toJson() => {"categories": categories.toJson()};
}

class CategoriesClass {
  final String href;
  final List<Item> items;
  final int limit;
  final String next;
  final int offset;
  final dynamic previous;
  final int total;

  CategoriesClass({
    required this.href,
    required this.items,
    required this.limit,
    required this.next,
    required this.offset,
    this.previous,
    required this.total,
  });

  CategoriesClass copyWith({
    String? href,
    List<Item>? items,
    int? limit,
    String? next,
    int? offset,
    dynamic previous,
    int? total,
  }) => CategoriesClass(
    href: href ?? this.href,
    items: items ?? this.items,
    limit: limit ?? this.limit,
    next: next ?? this.next,
    offset: offset ?? this.offset,
    previous: previous ?? this.previous,
    total: total ?? this.total,
  );

  factory CategoriesClass.fromRawJson(String str) =>
      CategoriesClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesClass.fromJson(Map<String, dynamic> json) =>
      CategoriesClass(
        href: json["href"] ?? "",
        items: List<Item>.from(
          json["items"]?.map((x) => Item.fromJson(x)) ?? [],
        ),
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
  final String href;
  final List<Icon> icons;
  final String id;
  final String name;

  Item({
    required this.href,
    required this.icons,
    required this.id,
    required this.name,
  });

  Item copyWith({String? href, List<Icon>? icons, String? id, String? name}) =>
      Item(
        href: href ?? this.href,
        icons: icons ?? this.icons,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    href: json["href"] ?? "",
    icons: List<Icon>.from(json["icons"]?.map((x) => Icon.fromJson(x)) ?? []),
    id: json["id"] ?? "",
    name: json["name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "icons": List<dynamic>.from(icons.map((x) => x.toJson())),
    "id": id,
    "name": name,
  };
}

class Icon {
  final int height;
  final String url;
  final int width;

  Icon({required this.height, required this.url, required this.width});

  Icon copyWith({int? height, String? url, int? width}) => Icon(
    height: height ?? this.height,
    url: url ?? this.url,
    width: width ?? this.width,
  );

  factory Icon.fromRawJson(String str) => Icon.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Icon.fromJson(Map<String, dynamic> json) => Icon(
    height: json["height"] ?? 0,
    url: json["url"] ?? "",
    width: json["width"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "url": url,
    "width": width,
  };
}
