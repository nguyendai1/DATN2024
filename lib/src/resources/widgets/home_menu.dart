import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/account/account_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../address/address_page.dart';
import '../../orders/order_page.dart';
import '../../posts/post_page.dart';
import '../../products/product_management.dart';
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
            leading: Icon(Icons.account_circle, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProfilePage())
                );
              },
              child: Text(
                "Tài khoản",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            )
        ),
        if (widget.isAdmin)
          ListTile(
            leading: Icon(Icons.directions_car, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProductManagementPage())
                );
              },
              child: Text(
                "Quản lý xe",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        if (widget.isAdmin)
          ListTile(
            leading: Icon(Icons.supervised_user_circle, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => RegisteredUsersPage())
                );
              },
              child: Text(
                "Quản lý tài khoản",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        if (widget.isAdmin)
          ListTile(
            leading: Icon(Icons.shopping_basket, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => OrdersFromStatisticsPage())
                );
              },
              child: Text(
                "Quản lý đơn hàng",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ListTile(
          leading: Icon(Icons.article_outlined, color: Colors.blue,),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PostsPage())
              );
            },
            child: Text(
              "Bài viết",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.blue,),
          title: TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => StoreMapPage(
                    storeName: 'Cửa hàng oto ICar',
                    address: 'Ngõ 80/52 đường Xuân Phương, Nam Từ Liêm, Hà Nội',
                    location: LatLng(21.047967323750214, 105.73427100970811),
                )),
              );
            },
            child: Text(
              "Địa chỉ",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
          ),
        ),
        if (widget.isAdmin)
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => StatisticsPage())
                );
              },
              child: Text(
                "Thống kê",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            ),
          ),
        ListTile(
            leading: Icon(Icons.logout, color: Colors.blue,),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginPage())
                );
              },
              child: Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 18, color: Color(0xff323643)),
              ),
            )
        )
      ],
    );
  }
}
