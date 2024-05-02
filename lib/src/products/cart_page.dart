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
        FirebaseAuth auth = FirebaseAuth.instance;
        // Nếu người dùng đã đăng nhập, tạo tham chiếu đến giỏ hàng của họ
        _userCartRef =
            FirebaseDatabase.instance.ref().child('carts').child(auth.currentUser!.uid);

        // Lắng nghe sự thay đổi trong giỏ hàng của người dùng
        _userCartRef.onValue.listen((event) {
          if (this.mounted) {
            if (event.snapshot.value != null) {
              setState(() {
                // Ép kiểu event.snapshot.value sang kiểu Map
                Object? data = event.snapshot.value;
                if (data is Map) {
                  // Truy cập thuộc tính values trên kiểu Map
                  cartItems = List<Map<dynamic, dynamic>>.from(data.values);
                }
              });
            }
          }
        });
      } else {
        // Nếu người dùng không đăng nhập, xóa giỏ hàng hiện tại
        setState(() {
          cartItems.clear();
        });
      }
    });
  }

  // Hàm tính tổng tiền của các sản phẩm trong giỏ hàng
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
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            title: Text(cartItem['name']),
            subtitle: Text('\$${cartItem['price'].toString()} x ${cartItem['quantity']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // Giảm số lượng sản phẩm
                    if (cartItem['quantity'] > 1) {
                      _decreaseQuantity(cartItem);
                    }
                  },
                ),
                Text(cartItem['quantity'].toString()), // Hiển thị số lượng hiện tại
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Tăng số lượng sản phẩm
                    _increaseQuantity(cartItem);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Xóa sản phẩm khỏi giỏ hàng của người dùng
                    _userCartRef.child(cartItem['key']!).remove();
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
        label: Text('Pay: \$${calculateTotalPrice().toStringAsFixed(2)}'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
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

  void _increaseQuantity(Map<dynamic, dynamic> cartItem) {
    if (cartItem.containsKey('key')) {
      int newQuantity = cartItem['quantity'] + 1;
      _updateQuantity(cartItem, newQuantity);
    }
  }

  void _decreaseQuantity(Map<dynamic, dynamic> cartItem) {
    int newQuantity = cartItem['quantity'] - 1;
    _updateQuantity(cartItem, newQuantity);
  }

  void _updateQuantity(Map<dynamic, dynamic> cartItem, int newQuantity) {
    _userCartRef.child(cartItem['key']!).update({
      'quantity': newQuantity,
    });
  }

}
