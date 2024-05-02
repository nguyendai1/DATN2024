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
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: bold17Grey,
                    ),
                    heightSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withOpacity(0.15),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: TextField(
                        cursorColor: primaryColor,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        style: semibold16Black,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: fixPadding * 1.4, horizontal: fixPadding * 1.5),
                          hintText: "Enter your name",
                          hintStyle: semibold16Grey,
                        ),
                      ),
                    )
                  ],
                ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: bold17Grey,
                ),
                heightSpace,
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.15),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: TextField(
                    cursorColor: primaryColor,
                    controller: _emailController,
                    keyboardType: TextInputType.name,
                    style: semibold16Black,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: fixPadding * 1.4, horizontal: fixPadding * 1.5),
                      hintText: "Enter your name",
                      hintStyle: semibold16Grey,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phone",
                  style: bold17Grey,
                ),
                heightSpace,
                Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: blackColor.withOpacity(0.15),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: TextField(
                    cursorColor: primaryColor,
                    controller: _phoneController,
                    keyboardType: TextInputType.name,
                    style: semibold16Black,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: fixPadding * 1.4, horizontal: fixPadding * 1.5),
                      hintText: "Enter your name",
                      hintStyle: semibold16Grey,
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: SizedBox()),
            Container(
              width: double.infinity,
              height: 70.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: updateUserProfile,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Màu cam
                ),
                child: Text('Update Profile'),
              )
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
          content: Text('Profile updated successfully'),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile: $error'),
        ));
      });
    }
  }
}
