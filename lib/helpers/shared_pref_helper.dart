import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();
  factory SharedPrefHelper() => _instance;
  SharedPrefHelper._internal();

  static SharedPreferences? _prefs;

  static const _keyUsers = 'users'; // daftar user terdaftar
  static const _keyLoggedIn = 'isLoggedIn';
  static const _keyCurrentUser = 'currentUser';

  // 🔹 Inisialisasi (panggil sekali di main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============================================================
  // 🔹 BAGIAN 1 — MENYIMPAN DAN MENGAMBIL DAFTAR USER
  // ============================================================

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final data = _prefs?.getString(_keyUsers);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return List<Map<String, dynamic>>.from(decoded);
  }

  Future<void> saveAllUsers(List<Map<String, dynamic>> users) async {
    final encoded = jsonEncode(users);
    await _prefs?.setString(_keyUsers, encoded);
  }

  // ============================================================
  // 🔹 BAGIAN 2 — REGISTER USER BARU
  // ============================================================

  Future<bool> registerUser(
    String fullname,
    String email,
    String username,
    String password,
  ) async {
    final users = await getAllUsers();

    // Cek apakah username sudah ada
    if (users.any((u) => u['username'] == username)) {
      return false;
    }

    users.add({
      'fullname': fullname,
      'email': email,
      'username': username,
      'password': password,
    });

    await saveAllUsers(users);
    return true;
  }

  // ============================================================
  // 🔹 BAGIAN 3 — LOGIN USER
  // ============================================================

  Future<bool> loginUser(String username, String password) async {
    final users = await getAllUsers();
    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      await _prefs?.setBool(_keyLoggedIn, true);
      await _prefs?.setString(_keyCurrentUser, jsonEncode(user));
      return true;
    }

    return false;
  }

  // ============================================================
  // 🔹 BAGIAN 4 — MENDAPATKAN USER AKTIF
  // ============================================================

  Map<String, dynamic>? getCurrentUser() {
    final data = _prefs?.getString(_keyCurrentUser);
    if (data == null) return null;
    return jsonDecode(data);
  }

  // ============================================================
  // 🔹 BAGIAN 5 — LOGOUT & STATUS LOGIN
  // ============================================================

  bool isLoggedIn() => _prefs?.getBool(_keyLoggedIn) ?? false;

  Future<void> logout() async {
    await _prefs?.remove(_keyLoggedIn);
    await _prefs?.remove(_keyCurrentUser);
  }

  // ============================================================
  // 🔹 BAGIAN 6 — RESET SEMUA DATA (jika perlu)
  // ============================================================

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
