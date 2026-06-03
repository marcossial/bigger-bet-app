import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _userIdKey = 'user_id';

  // Salva o ID do usuário após o login
  static Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
  }

  // Recupera o ID do usuário atualmente logado
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Limpa a sessão (Logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}
