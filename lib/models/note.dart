// To parse this JSON data, do
//     final note = noteFromJson(jsonString);

import 'dart:convert';

class Note {
  int? id;
  String title;
  String? title2;
  String content;
  
  Note({
    this.id,
    required this.title,
    this.title2,
    required this.content,
  });

  Note copyWith({
    int? id,
    String? title,
    String? title2,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      title2: title2 ?? this.title2,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'title2': title2,
      'content': content,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      title2: map['title2'],
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, title2: $title2, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Note &&
      other.id == id &&
      other.title == title &&
      other.title2 == title2 &&
      other.content == content;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      title2.hashCode ^
      content.hashCode;
  }
}
