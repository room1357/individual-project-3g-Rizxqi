import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/services/auth_service.dart';
import 'package:pemrograman_mobile/services/storage_service.dart';
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
  final _storage = StorageService();

  /// 🔹 Muat kategori user dari penyimpanan
  Future<void> loadCategories() async {
    final user = AuthService.instance.getCurrentUser();
    if (user == null) return;

    final data = await _storage.loadData('categories_${user.username}');
    if (data.isEmpty) return;

    _categories
      ..clear()
      ..addAll(data.map((e) => Category.fromJson(e)).toList());
  }

  /// 🔹 Simpan kategori ke penyimpanan
  Future<void> saveCategories() async {
    final user = AuthService.instance.getCurrentUser();
    if (user == null) return;

    await _storage.saveData(
      'categories_${user.username}',
      _categories.map((c) => c.toJson()).toList(),
    );
  }

  /// 🔹 Ambil semua kategori
  List<Category> getAll() => List.unmodifiable(_categories);

  /// 🔹 Tambahkan kategori baru
  Future<void> addCategory(Category category) async {
    if (_categories.any((c) => c.id == category.id)) {
      throw Exception("Kategori dengan ID ${category.id} sudah ada!");
    }
    _categories.add(category);
    await saveCategories();
  }

  /// 🔹 Update kategori berdasarkan ID
  Future<void> editCategory(Category updatedCategory) async {
    final index = _categories.indexWhere(
      (category) => category.id == updatedCategory.id,
    );
    if (index != -1) {
      _categories[index] = updatedCategory;
      await saveCategories();
    } else {
      throw Exception(
        "Kategori dengan ID ${updatedCategory.id} tidak ditemukan!",
      );
    }
  }

  /// 🔹 Hapus kategori berdasarkan ID
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((category) => category.id == id);
    await saveCategories();
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

  /// 🔹 Reset saat logout
  void clearAll() {
    _categories.clear();
  }
}
