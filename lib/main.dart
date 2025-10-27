import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // 🔹 Pastikan inisialisasi AuthService yang menggunakan SharedPreferences sudah selesai
  final auth = AuthService.instance;
  await auth.init();

  // 🔹 Cek apakah user masih login
  final bool isLoggedIn = await auth.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pengeluaran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        // menambahkan FutureBuilder splash (Plan)
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // menentukan halaman awal sesuai status login
          return isLoggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
