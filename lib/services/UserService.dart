import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserData(String uid, String name, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
  }

  // Lấy thông tin người dùng từ SharedPreferences
  Future<Map<String, String>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');

    // Kiểm tra nếu không có thông tin thì trả về một Map rỗng
    if (uid == null || name == null || email == null) {
      return {};
    } else {
      return {'uid': uid, 'name': name, 'email': email};
    }
  }

  // Xóa thông tin người dùng khi đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('name');
    await prefs.remove('email');
  }
}
