import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStore {
  static const _key = 'users';

  // ดึงรายชื่อผู้ใช้ทั้งหมด
  static Future<List<Map<String, dynamic>>> _all() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // เพิ่มผู้ใช้ใหม่
  static Future<void> add(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(user));
    await prefs.setStringList(_key, list);
  }

  // หา User ตาม username
  static Future<Map<String, dynamic>?> find(String username) async {
    final data = await _all();
    return data.firstWhere(
      (e) => e['username'] == username,
      orElse: () => {},
    );
  }

  // แก้รหัสผ่าน
  static Future<void> updatePassword(String username, String newPass) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    for (var i = 0; i < list.length; i++) {
      final m = jsonDecode(list[i]);
      if (m['username'] == username) {
        m['password'] = newPass;
        list[i] = jsonEncode(m);
        break;
      }
    }
    await prefs.setStringList(_key, list);
  }
}
