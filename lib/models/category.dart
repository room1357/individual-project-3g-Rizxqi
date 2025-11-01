import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String iconName;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
  });

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    Color? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
    );
  }
}
