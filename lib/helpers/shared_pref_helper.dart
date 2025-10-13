import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();

  factory SharedPrefHelper() {
    return _instance;
  }

  SharedPrefHelper._internal();

  static SharedPreferences? _prefs;

  // Inisialisasi (panggil di main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Simpan data user login
  Future<void> saveUser(String username, String password) async {
    await _prefs?.setString('username', username);
    await _prefs?.setString('password', password);
  }

  // Ambil data user
  String? getUsername() => _prefs?.getString('username');
  String? getPassword() => _prefs?.getString('password');

  // Simpan status login
  Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool('isLoggedIn', value);
  }

  bool isLoggedIn() => _prefs?.getBool('isLoggedIn') ?? false;

  // Logout
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
