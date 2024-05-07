import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';

import '../theme/theme.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  void getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _database.child('users').child(user.uid).once().then((DatabaseEvent snapshot) {
        DataSnapshot dataSnapshot = snapshot.snapshot;
        if (dataSnapshot.value != null && dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> userData = dataSnapshot.value as Map<dynamic, dynamic>;
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _emailController.text = user.email ?? '';
            _phoneController.text = userData['phone'] ?? '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản',style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Màu cam
                textStyle: TextStyle(color: Colors.black),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              ),
              child: Text('Cập nhật', style: bold18White),
            )
          ],
        ),
      ),
    );
  }

  void updateUserProfile() {
    User? user = _auth.currentUser;
    if (user != null) {
      _database.child('users').child(user.uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cập nhật hồ sơ thành công'),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi: $error'),
        ));
      });
    }
  }
}
