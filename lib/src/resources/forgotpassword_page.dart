import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _onSubmitClicked() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    try {
      DataSnapshot snapshot = await usersRef.once().then((event) => event.snapshot);
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? users = snapshot.value as Map<dynamic, dynamic>?;

        if (users != null && users.isNotEmpty) {
          bool isEmailFound = false;
          String password = '';

          users.forEach((key, value) {
            if (value['email'] == email) {
              isEmailFound = true;
              password = value['pass'];
            }
          });

          if (isEmailFound) {
            // Email found, you can now handle the password retrieval
            _showPassword(password);
          } else {
            // Email not found
            _showError('Email không tồn tại trong hệ thống.');
          }
        } else {
          _showError('Không có dữ liệu người dùng.');
        }
      } else {
        _showError('Dữ liệu người dùng không tồn tại.');
      }
    } catch (error) {
      print('Lỗi khi truy cập vào cơ sở dữ liệu: $error');
      _showError('Đã xảy ra lỗi, vui lòng thử lại sau.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showPassword(String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mật khẩu của bạn là:'),
          content: Text(password),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nhập địa chỉ Email của bạn để khôi phục mật khẩu:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _onSubmitClicked,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                "Gửi",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
