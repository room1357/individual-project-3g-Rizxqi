import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  // 🔹 Singleton pattern
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  User? currentUser;
  static const _keyUsername = 'username';
  static const _keyPassword = 'password'; // enkripsi
  static const _keyIsLoggedIn = 'isLoggedIn';

  final List<User> _userList = []; // variabel

  /// 🔹 Inisialisasi awal untuk memuat data user dari SharedPreferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      final username = prefs.getString(_keyUsername);
      final password = prefs.getString(_keyPassword);

      if (username != null && password != null) {
        currentUser = User(
          fullname:
              username, // Bisa kamu ubah kalau ada fullname di penyimpanan
          email: '',
          username: username,
          password: password,
        );
      }
    }
  }

  /// 🔹 Register user baru
  Future<bool> register(User newUser) async {
    // Cek apakah username sudah terdaftar
    final exists = _userList.any((u) => u.username == newUser.username);
    if (exists) return false;

    _userList.add(newUser);

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, newUser.username);
    await prefs.setString(_keyPassword, newUser.password);
    await prefs.setBool(_keyIsLoggedIn, true);

    currentUser = newUser;
    return true;
  }

  /// 🔹 Login user
  Future<bool> login(String username, String password) async {
    // Cari user di daftar (simulasi database)
    final user = _userList.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => User(fullname: '', email: '', username: '', password: ''),
    );

    if (user.username.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUsername, user.username);
      await prefs.setString(_keyPassword, user.password);
      await prefs.setBool(_keyIsLoggedIn, true);

      currentUser = user;
      return true;
    }

    // Kalau user tidak ditemukan di list (misal app restart), cek SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_keyUsername);
    final savedPassword = prefs.getString(_keyPassword);

    if (savedUsername == username && savedPassword == password) {
      currentUser = User(
        fullname: username,
        email: '',
        username: username,
        password: password,
      );
      return true;
    }

    return false;
  }

  /// 🔹 Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser = null;
  }

  /// 🔹 Mengecek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// 🔹 Ambil data user yang sedang login
  User? getCurrentUser() {
    return currentUser;
  }
}
