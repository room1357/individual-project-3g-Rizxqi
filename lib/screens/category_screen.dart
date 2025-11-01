import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final service = CategoryService();

  @override
  Widget build(BuildContext context) {
    final categories = service.getAll();
    for (var cat in categories) {
      if (!cupertinoIcons.containsKey(cat.iconName)) {
        debugPrint('❌ BAD ICON FOUND:');
        debugPrint('   Category: ${cat.name}');
        debugPrint('   Icon: ${cat.iconName}');
        debugPrint('   Valid icons: ${cupertinoIcons.keys.toList()}');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Select Category",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for Categories",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  if (index == categories.length) {
                    return _buildAddButton(context);
                  }
                  final c = categories[index];
                  return _buildCategoryItem(c);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Category c) {
    final iconData = cupertinoIcons[c.iconName];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _showCategoryOptions(c),
              child: const Icon(
                Icons.more_vert,
                size: 18,
                color: Colors.black45,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: c.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    cupertinoIcons[c.iconName] ??
                        CupertinoIcons.question_circle,
                    color: c.color,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  c.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newCategory = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AddCategoryScreen(
                  onSave: (newCategory) {
                    setState(() {
                      service.addCategory(newCategory);
                    });
                  },
                  availableIcons: cupertinoIcons,
                ),
          ),
        );

        if (newCategory != null && newCategory is Category) {
          setState(() {
            service.addCategory(newCategory);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 23,
              backgroundColor: Color(0xFF7B61FF),
              child: Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Add",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryOptions(Category c) {
    // ✅ TAMBAH DEBUG
    debugPrint('🔍 Category ID: ${c.id}');
    debugPrint('🔍 Category Name: ${c.name}');
    debugPrint('🔍 Icon Name: ${c.iconName}');
    debugPrint('🔍 Icon exists: ${cupertinoIcons.containsKey(c.iconName)}');
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              ListTile(
                // ✅ FIX: Tambah null safety
                leading: Icon(
                  cupertinoIcons[c.iconName] ?? CupertinoIcons.question_circle,
                  color: c.color,
                ),
                title: Text(
                  c.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: Text(
                  "Edit",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Close bottom sheet

                  // ✅ ADD: Debug logging
                  debugPrint('📝 Opening edit for: ${c.id} - ${c.name}');

                  try {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCategoryScreen(category: c),
                      ),
                    );

                    if (result != null && mounted) {
                      setState(() {});
                    }
                  } catch (e) {
                    debugPrint('❌ Edit error: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal membuka edit: $e'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: Text(
                  "Delete",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context); // Close bottom sheet first

                  // ✅ TAMBAH KONFIRMASI DELETE
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Hapus Kategori'),
                          content: Text('Yakin ingin menghapus "${c.name}"?'),
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
                    setState(() {
                      service.deleteCategory(c.id);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${c.name} berhasil dihapus'),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.grey),
                title: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
