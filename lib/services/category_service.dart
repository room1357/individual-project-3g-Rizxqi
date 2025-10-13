import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryService {
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Groceries',
      icon: Icons.shopping_bag_outlined,
      color: Colors.green,
    ),
    Category(
      id: '2',
      name: 'Travel',
      icon: Icons.flight_takeoff,
      color: Colors.blueAccent,
    ),
    Category(
      id: '3',
      name: 'Car',
      icon: Icons.directions_car,
      color: Colors.indigo,
    ),
    Category(
      id: '4',
      name: 'Home',
      icon: Icons.home_outlined,
      color: Colors.deepPurpleAccent,
    ),
    Category(
      id: '5',
      name: 'Education',
      icon: Icons.school_outlined,
      color: Colors.teal,
    ),
    Category(id: '6', name: 'Internet', icon: Icons.wifi, color: Colors.orange),
    Category(
      id: '7',
      name: 'Rent',
      icon: Icons.house_outlined,
      color: Colors.redAccent,
    ),
    Category(
      id: '8',
      name: 'Vacation',
      icon: Icons.beach_access_outlined,
      color: Colors.lightGreen,
    ),
    Category(
      id: '9',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
  ];

  List<Category> getAll() => _categories;
}
