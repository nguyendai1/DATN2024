// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_car/src/products/pay_page.dart';
// import '../theme/theme.dart';
//
// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//   late DatabaseReference _userCartRef;
//   List<Map<dynamic, dynamic>> cartItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user != null) {
//         String userId = user.uid;
//         _userCartRef = FirebaseDatabase.instance.ref().child('carts').child(userId);
//
//         _userCartRef.onValue.listen((event) {
//           if (this.mounted) {
//             if (event.snapshot.value != null) {
//               var data = event.snapshot.value;
//               if (data is Map<dynamic, dynamic>) {
//                 setState(() {
//                   cartItems = List<Map<dynamic, dynamic>>.from(data.values);
//                 });
//               }
//             }
//           }
//         });
//       } else {
//         setState(() {
//           cartItems.clear();
//         });
//       }
//     });
//   }
//
//   double calculateTotalPrice() {
//     double totalPrice = 0;
//     for (var item in cartItems) {
//       totalPrice += item['price'] * item['quantity'];
//     }
//     return totalPrice;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Giỏ hàng', style: bold18White),
//         backgroundColor: primaryColor,
//       ),
//       body: ListView.builder(
//         itemCount: cartItems.length,
//         itemBuilder: (context, index) {
//           final cartItem = cartItems[index];
//           return ListTile(
//             leading: Image.network(cartItems[index]['imageUrls'] ?? '', width: 70, height: 70,),
//             title: Text(cartItem['name'], style: TextStyle(fontWeight: FontWeight.bold),),
//             subtitle: Text('${cartItem['price'].toString()} tr VND\nSố lượng: ${cartItem['quantity']}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     _userCartRef.child(cartItem['key']).remove();
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           navigateToPaymentPage(context);
//         },
//         label: Row(
//           children: [
//             Icon(Icons.shopping_cart),
//             SizedBox(width: 10),
//             Text('Thanh toán: ${calculateTotalPrice().toStringAsFixed(0)} tr VND'),
//           ],
//         ),
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.black,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//       ),
//     );
//   }
//
//   void navigateToPaymentPage(BuildContext context) {
//     double totalPrice = calculateTotalPrice();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(totalPrice: totalPrice),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/products/pay_page.dart';
import '../theme/theme.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late DatabaseReference _userCartRef;
  List<Map<dynamic, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        String userId = user.uid;
        _userCartRef = FirebaseDatabase.instance.ref().child('carts').child(userId);

        _userCartRef.onValue.listen((event) {
          if (this.mounted) {
            if (event.snapshot.value != null) {
              var data = event.snapshot.value;
              if (data is Map<dynamic, dynamic>) {
                setState(() {
                  cartItems = data.entries.map((entry) {
                    Map<dynamic, dynamic> item = Map.from(entry.value);
                    item['key'] = entry.key;
                    return item;
                  }).toList();
                });
              }
            } else {
              setState(() {
                cartItems.clear();
              });
            }
          }
        });
      } else {
        setState(() {
          cartItems.clear();
        });
      }
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item['price'] * item['quantity'];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng', style: bold18White),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            leading: Image.network(cartItem['imageUrls'] ?? '', width: 70, height: 70,),
            title: Text(cartItem['name'], style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('${cartItem['price'].toString()} tr VND\nSố lượng: ${cartItem['quantity']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteCartItem(cartItem['key']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToPaymentPage(context);
        },
        label: Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 10),
            Text('Thanh toán: ${calculateTotalPrice().toStringAsFixed(0)} tr VND'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  void _deleteCartItem(String key) {
    _userCartRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Đã xóa sản phẩm khỏi giỏ hàng.'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi khi xóa sản phẩm: $error'),
      ));
    });
  }

  void navigateToPaymentPage(BuildContext context) {
    double totalPrice = calculateTotalPrice();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(totalPrice: totalPrice),
      ),
    );
  }
}
