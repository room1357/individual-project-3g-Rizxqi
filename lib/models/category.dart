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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] ?? 'default_item',
      color: Color(json['color'] ?? Colors.grey.value),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'iconName': iconName, 'color': color.value};
  }

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
