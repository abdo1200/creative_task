// To parse this JSON data, do
//
//     final repository = repositoryFromJson(jsonString);

import 'dart:convert';

List<Repository> repositoryFromJson(String str) =>
    List<Repository>.from(json.decode(str).map((x) => Repository.fromJson(x)));

class Repository {
  Repository({
    required this.name,
    required this.fullName,
    required this.owner,
    required this.htmlUrl,
    this.description,
    required this.fork,
  });

  String name;
  String fullName;
  Owner owner;
  String htmlUrl;
  String? description;
  bool fork;

  factory Repository.fromJson(Map<String, dynamic> json) => Repository(
        name: json["name"],
        fullName: json["full_name"],
        owner: Owner.fromJson(json["owner"]),
        htmlUrl: json["html_url"],
        description: json["description"],
        fork: json["fork"],
      );
}

class Owner {
  Owner({
    required this.login,
    required this.htmlUrl,
  });

  Login login;
  String htmlUrl;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        login: loginValues.map[json["login"]]!,
        htmlUrl: json["html_url"],
      );
}

enum Login { SQUARE }

final loginValues = EnumValues({"square": Login.SQUARE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
