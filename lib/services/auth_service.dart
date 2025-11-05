import '../models/user.dart';
import 'expense_service.dart';
import 'category_service.dart';
import '../helpers/shared_pref_helper.dart';

class AuthService {
  // 🔹 Singleton
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  User? currentUser;

  final _prefs = SharedPrefHelper();

  // ============================================================
  // 🔹 INISIALISASI APLIKASI SAAT START
  // ============================================================
  Future<void> init() async {
    if (_prefs.isLoggedIn()) {
      final userData = _prefs.getCurrentUser();
      if (userData != null) {
        currentUser = User(
          fullname: userData['fullname'] ?? '',
          email: userData['email'] ?? '',
          username: userData['username'] ?? '',
          password: userData['password'] ?? '',
        );

        // 🔹 Load data milik user ini
        await ExpenseService().loadExpenses();
        await CategoryService().loadCategories();
      }
    }
  }

  // ============================================================
  // 🔹 REGISTER USER BARU
  // ============================================================
  Future<bool> register(User newUser) async {
    final success = await _prefs.registerUser(
      newUser.fullname,
      newUser.email,
      newUser.username,
      newUser.password,
    );

    if (success) {
      currentUser = newUser;
      await _prefs.loginUser(newUser.username, newUser.password);
    }

    return success;
  }

  // ============================================================
  // 🔹 LOGIN USER
  // ============================================================
  Future<bool> login(String username, String password) async {
    final success = await _prefs.loginUser(username, password);

    if (success) {
      final userData = _prefs.getCurrentUser();
      if (userData != null) {
        currentUser = User(
          fullname: userData['fullname'] ?? '',
          email: userData['email'] ?? '',
          username: userData['username'] ?? '',
          password: userData['password'] ?? '',
        );

        // 🔹 Muat data user
        await ExpenseService().loadExpenses();
        await CategoryService().loadCategories();
      }
    }

    return success;
  }

  // ============================================================
  // 🔹 LOGOUT USER
  // ============================================================
  Future<void> logout() async {
    await _prefs.logout();
    currentUser = null;
  }

  // ============================================================
  // 🔹 CEK STATUS LOGIN
  // ============================================================
  bool isLoggedIn() {
    return _prefs.isLoggedIn();
  }

  // ============================================================
  // 🔹 AMBIL USER AKTIF SAAT INI
  // ============================================================
  User? getCurrentUser() {
    return currentUser;
  }
}
