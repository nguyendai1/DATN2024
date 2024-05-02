import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../fire_base/auth_service.dart';
import 'product_detail_page.dart'; // Import trang trước đó để điều hướng người dùng sau khi xóa

class DeleteProductPage extends StatelessWidget {
  final Map<dynamic, dynamic> product;

  const DeleteProductPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Product'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to delete ${product['name']}?'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _confirmDelete(context);
                  },
                  child: Text('Delete'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Đóng trang xóa sản phẩm và quay lại trang trước đó
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                _performDelete(context);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                // Đóng hộp thoại và không thực hiện hành động xóa
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(BuildContext context) {
    DatabaseReference productsRef = FirebaseDatabase.instance.ref().child('products');
    String productId = product['id'];
    productsRef.child(productId).remove().then((_) {
      // Đóng trang xóa sản phẩm và quay lại trang trước đó
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to delete product: $error');
    });
  }
}
