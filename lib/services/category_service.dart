import '../models/category.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final List<Category> _categories = [
    Category(id: '1', name: 'Makanan', icon: '🍔'),
    Category(id: '2', name: 'Transportasi', icon: '🛵'),
    Category(id: '3', name: 'Hiburan', icon: '🎬'),
    Category(id: '4', name: 'Utilitas', icon: '💡'),
    Category(id: '5', name: 'Pendidikan', icon: '📚'),
  ];

  List<Category> getAll() => List.unmodifiable(_categories);

  void addCategory(Category category) {
    _categories.add(category);
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
  }
}
