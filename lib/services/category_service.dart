import 'package:flutter/material.dart';
import '../models/category.dart';
import 'package:flutter/cupertino.dart';

final Map<String, IconData> cupertinoIcons = {
  'housing': CupertinoIcons.house,
  'utilities': CupertinoIcons.bolt,
  'food_drink': CupertinoIcons.cart,
  'transportation': CupertinoIcons.car_detailed,
  'health': CupertinoIcons.heart,
  'savings': CupertinoIcons.briefcase,
  'entertainment': CupertinoIcons.game_controller,
  'shopping': CupertinoIcons.bag,
  'education': CupertinoIcons.book,
  'other': CupertinoIcons.question_circle,
};

class CategoryService {
  // ✅ TAMBAH SINGLETON
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Food',
      iconName: 'food_drink',
      color: Colors.orange,
    ),
    Category(
      id: '2',
      name: 'Transport',
      iconName: 'transportation',
      color: Colors.blue,
    ),
    Category(
      id: '3',
      name: 'Entertainment',
      iconName: 'entertainment',
      color: Colors.purple,
    ),
    Category(
      id: '4',
      name: 'Shopping',
      iconName: 'shopping',
      color: Colors.pink,
    ),
    Category(id: '5', name: 'Health', iconName: 'health', color: Colors.red),
  ];

  /// 🔹 Ambil semua kategori
  List<Category> getAll() => List.unmodifiable(_categories);

  /// 🔹 Tambahkan kategori baru
  void addCategory(Category category) {
    if (_categories.any((c) => c.id == category.id)) {
      throw Exception("Kategori dengan ID ${category.id} sudah ada!");
    }
    _categories.add(category);
  }

  /// 🔹 Update kategori berdasarkan ID
  void editCategory(Category updatedCategory) {
    final index = _categories.indexWhere(
      (category) => category.id == updatedCategory.id,
    );
    if (index != -1) {
      _categories[index] = updatedCategory;
    } else {
      throw Exception(
        "Kategori dengan ID ${updatedCategory.id} tidak ditemukan!",
      );
    }
  }

  /// 🔹 Hapus kategori berdasarkan ID
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
  }

  /// 🔹 Cari kategori berdasarkan ID (return null kalau tidak ada) ✅ FIX
  Category? getById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null; // ✅ Return null, bukan dummy object
    }
  }

  /// 🔹 Get category dengan fallback ✅ TAMBAH
  Category getCategoryOrDefault(String id) {
    return getById(id) ??
        Category(
          id: '0',
          name: 'Lain-lain',
          iconName: 'other',
          color: Colors.grey,
        );
  }

  /// 🔹 Validate if icon exists
  bool isValidIcon(String iconName) {
    return cupertinoIcons.containsKey(iconName);
  }

  /// 🔹 Get icon or default
  String getValidIconName(String iconName) {
    return cupertinoIcons.containsKey(iconName) ? iconName : 'other';
  }

  /// 🔹 Get count
  int get count => _categories.length;
}
