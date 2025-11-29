import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category category;

  const EditCategoryScreen({super.key, required this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  late String selectedIconName;
  late Color selectedColor;

  final categoryService = CategoryService();

  // ✅ NO LOCAL ICON MAP - use cupertinoIcons from service

  final List<Color> availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();

    nameController.text = widget.category.name;
    selectedColor = widget.category.color;

    // ✅ CRITICAL FIX: Validate icon exists
    if (cupertinoIcons.containsKey(widget.category.iconName)) {
      selectedIconName = widget.category.iconName;
      debugPrint('✅ Icon "${widget.category.iconName}" is valid');
    } else {
      selectedIconName = 'other';
      debugPrint(
        '⚠️ Icon "${widget.category.iconName}" not found, using "other"',
      );
      debugPrint('   Available icons: ${cupertinoIcons.keys.toList()}');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateCategory() {
    if (_formKey.currentState!.validate()) {
      final updatedCategory = Category(
        id: widget.category.id,
        name: nameController.text.trim(),
        iconName: selectedIconName,
        color: selectedColor,
      );

      try {
        categoryService.editCategory(updatedCategory);

        if (!mounted) return;
        Navigator.pop(context, updatedCategory);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${updatedCategory.name} berhasil diperbarui'),
            backgroundColor: Colors.deepPurpleAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deleteCategory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Kategori'),
            content: Text(
              'Apakah Anda yakin ingin menghapus kategori "${widget.category.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirm == true && mounted) {
      try {
        categoryService.deleteCategory(widget.category.id);
        Navigator.pop(context, 'deleted');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.category.name} telah dihapus'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // ✅ FIX: Convert to list ONCE outside builder
        final iconEntries = cupertinoIcons.entries.toList();

        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                'Pilih Icon',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: iconEntries.length, // ✅ FIXED: Use list length
                  itemBuilder: (context, index) {
                    final entry =
                        iconEntries[index]; // ✅ FIXED: Direct list access
                    final isSelected = selectedIconName == entry.key;

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIconName = entry.key);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? selectedColor.withOpacity(0.2)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? selectedColor : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          entry.value,
                          color: isSelected ? selectedColor : Colors.grey[600],
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    // ... keep your existing color picker code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Edit Kategori",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _deleteCategory,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B61FF), Color(0xFFFB7BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: selectedColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        cupertinoIcons[selectedIconName] ?? // ✅ FIXED
                            CupertinoIcons.question_circle,
                        color: selectedColor,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nama Kategori
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Kategori",
                      prefixIcon: const Icon(Icons.label),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (val) =>
                            val == null || val.trim().isEmpty
                                ? 'Nama kategori tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Icon Picker
                  InkWell(
                    onTap: _showIconPicker,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Icon',
                        prefixIcon: const Icon(Icons.apps),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                cupertinoIcons[selectedIconName] ?? // ✅ FIXED
                                    CupertinoIcons.question_circle,
                                color: selectedColor,
                              ),
                              const SizedBox(width: 8),
                              Text(selectedIconName),
                            ],
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),

                  // ... rest of your form fields
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
