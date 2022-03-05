// To parse this JSON data, do
//     final note = noteFromJson(jsonString);

import 'dart:convert';

List<Note> noteFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String noteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  Note({
    this.id,
    required this.title,
    this.title2,
    required this.content,
  });

  int? id;
  String title;
  String? title2;
  String content;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        title2: json["title2"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "title2": title2,
        "content": content,
      };

  Note copy({
    int? id,
    String? title,
    String? title2,
    String? content,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        title2: title2 ?? this.title2,
        content: content ?? this.content,
      );
}
