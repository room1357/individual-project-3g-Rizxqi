import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final nameController = TextEditingController();
  final iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = CategoryService();
    final categories = service.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text("Kategori")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final c = categories[index];
          return ListTile(
            leading: Text(c.icon, style: const TextStyle(fontSize: 24)),
            title: Text(c.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                service.deleteCategory(c.id);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryScreen()),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: const Text("Tambah Kategori"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Nama"),
                      ),
                      TextField(
                        controller: iconController,
                        decoration: const InputDecoration(
                          labelText: "Icon Emoji",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final newCat = Category(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          icon:
                              iconController.text.isEmpty
                                  ? "❓"
                                  : iconController.text,
                        );
                        service.addCategory(newCat);
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => CategoryScreen()),
                        );
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
