import 'package:flutter/material.dart';
import '../models/category.dart';
import 'dart:math';

class AddCategoryScreen extends StatefulWidget {
  final Category? category;
  final void Function(Category) onSave;
  final Map<String, IconData> availableIcons;

  const AddCategoryScreen({
    super.key,
    this.category,
    required this.onSave,
    required this.availableIcons,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedIcon;
  late Color _selectedColor;

  final List<Color> _colorOptions = const [
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent,
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon =
        widget.category?.iconName ?? widget.availableIcons.keys.first;
    _selectedColor = widget.category?.color ?? Colors.blueAccent;
  }

  void _pickColor() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => GridView.count(
            crossAxisCount: 4,
            padding: const EdgeInsets.all(16),
            children:
                _colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = color);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black26,
                          width: _selectedColor == color ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final id = widget.category?.id ?? Random().nextInt(9999).toString();
      final newCategory = Category(
        id: id,
        name: _nameController.text.trim(),
        iconName: _selectedIcon,
        color: _selectedColor,
      );

      widget.onSave(newCategory);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null ? 'Add Category' : 'Edit Category',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Input nama kategori
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a name'
                            : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Pilihan ikon (sinkron dengan CupertinoIcons map)
              DropdownButtonFormField<String>(
                initialValue: _selectedIcon,
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  border: OutlineInputBorder(),
                ),
                items:
                    widget.availableIcons.entries.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.key,
                        child: Row(
                          children: [
                            Icon(e.value, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(e.key.replaceAll('_', ' ').toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _selectedIcon = value!),
              ),
              const SizedBox(height: 16),

              // 🔹 Pilihan warna
              Row(
                children: [
                  const Text(
                    'Color:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _pickColor,
                    child: CircleAvatar(
                      backgroundColor: _selectedColor,
                      radius: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
