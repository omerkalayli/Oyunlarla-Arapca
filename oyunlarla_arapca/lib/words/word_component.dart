import 'package:flutter/material.dart';

class WordComponent {
  WordComponent({required this.id, required this.book, required this.author});

  final int id;
  final String book;
  final String author;

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'author': author,
      'id': id,
    };
  }

  factory WordComponent.fromJson(Map<String, dynamic> json) {
    return WordComponent(
      book: json['book'],
      author: json['author'],
      id: json['id'],
    );
  }
}
