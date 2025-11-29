import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:pemrograman_mobile/models/expense_manager.dart';
import 'package:pemrograman_mobile/screens/looping_expense_screen.dart';
import 'login_screen.dart';
import 'advanced_list_screen.dart';
=======
import '../services/auth_service.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import 'login_screen.dart';
import 'expense_list_screen.dart';
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // ✅ bikin instance di sini (tidak bisa pakai const)
  final ExpenseManager manager = ExpenseManager();

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final currentUser = auth.currentUser; // ✅ Ambil user aktif dari singleton

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await _showLogoutDialog(context);
              if (confirm == true) {
                await auth.logout(); // ✅ reset user di singleton
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              }
            },
<<<<<<< HEAD
            icon: const Icon(Icons.logout),
=======
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
=======
            // 👇 sapaan dinamis
            Text(
              'Hai, ${currentUser?.fullname ?? 'Pengguna'} 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selamat datang di aplikasi pengelola keuangan Anda',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
<<<<<<< HEAD
            const SizedBox(height: 20),
=======
            const SizedBox(height: 16),
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
<<<<<<< HEAD
                    'Pengeluaran Advanced',
                    Icons.attach_money,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const AdvancedExpenseListScreen(), // ✅ tanpa manager
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    'Pengeluaran Biasa',
                    Icons.attach_money,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoopingExamplesScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard('Profil', Icons.person, Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  }),
                  _buildDashboardCard(
                    'Pesan',
                    Icons.message,
                    Colors.orange,
                    null,
=======
                    context,
                    title: 'Pengeluaran',
                    icon: Icons.account_balance_wallet_outlined,
                    color: Colors.green,
                    onTap: () => _navigate(context, const ExpenseListScreen()),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Statistik',
                    icon: Icons.bar_chart_rounded,
                    color: const Color.fromARGB(255, 0, 204, 255),
                    onTap: () => _navigate(context, const StatisticsScreen()),
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Kategori',
                    icon: Icons.category_rounded,
                    color: const Color.fromARGB(255, 209, 255, 3),
                    onTap: () => _navigate(context, CategoryScreen()),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Profil',
                    icon: Icons.person_rounded,
                    color: Colors.blue,
                    onTap: () => _navigate(context, const ProfileScreen()),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Pesan',
                    icon: Icons.message_rounded,
                    color: Colors.orange,
                    onTap: null,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Pengaturan',
                    icon: Icons.settings_rounded,
                    color: Colors.purple,
                    onTap: () => _navigate(context, const SettingsScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 helper untuk card navigasi
  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
<<<<<<< HEAD
      elevation: 4,
      child: Builder(
        builder:
            (context) => InkWell(
              onTap:
                  onTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fitur $title segera hadir!')),
                    );
                  },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 48, color: color),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
=======
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap:
            onTap ??
            () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fitur "$title" segera hadir!')),
            ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
>>>>>>> 2b127b3c0acd27fcccc51bf6af13f2665870d3d9
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 helper untuk navigasi antar halaman
  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // 🔹 dialog konfirmasi logout
  Future<bool?> _showLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari akun ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
