import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Danh sách các email của admin
  final List<String> adminEmails = ['admin@gmail.com'];

  Future<bool> checkUserRole() async {
    // Lấy thông tin về người dùng hiện tại từ Firebase Auth
    User? user = _auth.currentUser;
    if (user != null) {
      // Kiểm tra xem email của người dùng có trong danh sách admin hay không
      return adminEmails.contains(user.email);
    } else {
      return false;
    }
  }
}
