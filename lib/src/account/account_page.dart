import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách tài khoản'),
      ),
      body: FutureBuilder(
        future: _getAccountList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['username']),
                  subtitle: Text(snapshot.data?[index]['email']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAccount(snapshot.data?[index]['key']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> _getAccountList() async {
    try {
      DataSnapshot snapshot = (await _database.child('accounts').once()) as DataSnapshot;
      List<Map<String, dynamic>> accountList = [];
      if (snapshot.value != null && snapshot.value is Map) {
        (snapshot.value as Map).forEach((key, value) {
          accountList.add({'key': key, ...value});
        });
      }
      return accountList;
    } catch (e) {
      print("Error fetching account list: $e");
      return null;
    }
  }

  Future<void> _deleteAccount(String key) async {
    await _database.child('accounts').child(key).remove();
    setState(() {}); // Refresh danh sách tài khoản sau khi xóa
  }
}
