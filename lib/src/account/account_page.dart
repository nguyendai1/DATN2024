import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class RegisteredUsersPage extends StatefulWidget {
  @override
  _RegisteredUsersPageState createState() => _RegisteredUsersPageState();
}

class _RegisteredUsersPageState extends State<RegisteredUsersPage> {
  List<String> userEmails = [];
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
      usersRef.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> users = (event.snapshot.value as Map<dynamic, dynamic>);
          List<String> emails = [];
          List<String> names = [];
          users.forEach((key, value) {
            String email = value['email'] ?? 'Unknown';
            String name = value['name'] ?? 'Unknown';
            emails.add(email);
            names.add(name);
          });
          setState(() {
            userEmails = emails;
            userNames = names;
          });
        }
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _deleteUser(int index) async {
    try {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
      usersRef.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> users = (event.snapshot.value as Map<dynamic, dynamic>);
          String userId = users.keys.elementAt(index);
          usersRef.child(userId).remove().then((_) {
            setState(() {
              userEmails.removeAt(index);
              userNames.removeAt(index);
            });
          });
        }
      });
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài khoản', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: userEmails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: userEmails.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  '${userNames[index]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${userEmails[index]}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteUser(index),
                ),
              ),
              Divider(
                color: Colors.grey[400],
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
