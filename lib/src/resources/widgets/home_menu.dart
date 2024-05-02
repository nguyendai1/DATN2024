import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/account/account_page.dart';

import '../../profile/profile.dart';
import '../../statistic/statistic_page.dart';
import '../login_page.dart';

class HomeMenu extends StatefulWidget {
  final bool isAdmin;
  const HomeMenu({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Image.asset('assets/icons/ic_menu_user.png'),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProfilePage())
              );
            },
            child: Text(
            "My Profile",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
          )
        ),
        if (widget.isAdmin)
          ListTile(
            leading: Image.asset(
                width: 24,
                height: 24,
                'assets/icons/ic_menu_user.png'), // Icon cho nút Thống kê
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AccountPage())
                );
              },
              child: Text(
                "Account", // Tiêu đề của nút Thống kê
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ListTile(
          leading: Image.asset('assets/icons/ic_menu_notify.png'),
          title: Text(
            "Notifications",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        ListTile(
          leading: Image.asset('assets/icons/ic_menu_help.png'),
          title: Text(
            "Help & Supports",
            style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        ),
        if (widget.isAdmin)
          ListTile(
            leading: Image.asset(
                width: 24,
                height: 24,
                'assets/icons/ic_menu_statistic.png'), // Icon cho nút Thống kê
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => StatisticsPage())
                );
              },
              child: Text(
                "Statistic", // Tiêu đề của nút Thống kê
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ListTile(
          leading: Image.asset('assets/icons/ic_menu_logout.png'),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LoginPage())
              );
            },
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
          ),
        )
        )
      ],
    );
  }
}
