import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

import 'cart_page.dart';
import 'edit_product.dart';

class ProductDetailPage extends StatefulWidget {
  final String productKey;
  final bool isAdmin;

  ProductDetailPage({required this.productKey, required this.isAdmin});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late DatabaseReference _productsRef;
  Map<dynamic, dynamic>? productData;
  List<String>? imageUrls;

  @override
  void initState() {
    super.initState();
    _productsRef = FirebaseDatabase.instance.ref().child('products');
    _loadProductData();
  }

  void _loadProductData() {
    _productsRef.child(widget.productKey).once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          productData = data;
          imageUrls = List<String>.from(data['imageUrls'] ?? []);
        });

        findSamePriceProducts();
      }
    }).catchError((error) {
      print("Error loading product data: $error");
    });
  }

  List<Map<dynamic, dynamic>> samePriceProducts = [];

  Future<void> findSamePriceProducts() async {
    try {
      double currentProductPrice = productData!['price'].toDouble(); // Lấy giá sản phẩm hiện tại

      DatabaseReference productRef = FirebaseDatabase.instance.ref().child('products');

      // Lấy snapshot của dữ liệu từ cơ sở dữ liệu Firebase
      DataSnapshot snapshot = await productRef.once().then((event) => event.snapshot);

      // Lấy giá trị từ snapshot
      Map<dynamic, dynamic>? products = snapshot.value as Map<dynamic, dynamic>?;

      // Kiểm tra và thêm các sản phẩm có cùng giá vào danh sách samePriceProducts
      if (products != null) {
        products.forEach((key, value) {
          double price = value['price'].toDouble(); // Lấy giá của sản phẩm từ dữ liệu Firebase
          if (price == currentProductPrice && key != widget.productKey) {
            setState(() {
              samePriceProducts.add({...value, 'key': key}); // Lưu cả khóa và giá trị của sản phẩm
            });
          }
        });
      }
    } catch (error) {
      print('Lỗi tìm sản phẩm cùng giá: $error');
    }
  }

  Widget buildSamePriceProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Các sản phẩm cùng giá:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: samePriceProducts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(samePriceProducts[index]['name']),
              subtitle: Text('${samePriceProducts[index]['price']}tr VND'),
              leading: Image.network(
                samePriceProducts[index]['imageUrls']?[0] ?? '', // Lấy ảnh đầu tiên trong danh sách ảnh
                fit: BoxFit.cover,
                width: 60, // Kích thước của ảnh
                height: 60,
              ),
              onTap: () {
                // Điều hướng đến trang chi tiết sản phẩm của sản phẩm cùng giá
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(productKey: samePriceProducts[index]['key'], isAdmin: widget.isAdmin,),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm', style: bold18White,),
        backgroundColor: primaryColor,
        actions: [
          if (widget.isAdmin)
            IconButton(
              onPressed: () {
                _editProduct();
              },
              icon: Icon(Icons.edit),
            ),
        ],
      ),
      body: productData != null
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (imageUrls != null && imageUrls!.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: PageView.builder(
                    itemCount: imageUrls!.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        imageUrls![index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              Text('${productData!['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('Giá: ${productData!['price']}tr VND', style: TextStyle(fontSize: 18),),
              Text('Màu sắc: ${productData!['color']}', style: TextStyle(fontSize: 18),),
              Text('Thương hiệu: ${productData!['brand']}', style: TextStyle(fontSize: 18),),
              Text('Số lượng: ${productData!['quantity']}', style: TextStyle(fontSize: 18),),
              Text('Tình trạng: ${productData!['status']}', style: TextStyle(fontSize: 18),),
              Text('Mô tả: ${productData!['description']}', style: TextStyle(fontSize: 18),),
              buildSamePriceProducts(),
            ],
          ),
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addToCart();
        },
        child: Icon(Icons.add_shopping_cart),
        backgroundColor: primaryColor,
      ),
      // floatingActionButton: ElevatedButton(
      //   onPressed: () {
      //     _addToCart();
      //   },
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(Icons.add_shopping_cart, color: Colors.white,),
      //       SizedBox(width: 8),
      //       Text('Thêm vào giỏ hàng', style: bold18White,),
      //     ],
      //   ),
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: primaryColor,
      //     fixedSize: Size(280, 60),
      //     alignment: Alignment.center,
      //   ),
      // ),
    );
  }

  void _editProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(productKey: widget.productKey),
      ),
    );
  }

  void _addToCart() {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('carts').child(auth.currentUser!.uid);

    try {
      if (productData != null) {
        int quantity = productData!['quantity'];

        if (quantity > 0) {
          bool isProductExistInCart = false;
          String? existingProductKey;

          cartRef.once().then((DatabaseEvent event) {
            DataSnapshot snapshot = event.snapshot;
            Map<dynamic, dynamic>? cartItems = snapshot.value as Map?;

            if (cartItems != null) {
              cartItems.forEach((key, value) {
                if (value['name'] == productData!['name']) {
                  existingProductKey = key;
                  isProductExistInCart = true;
                }
              });
            }

            if (isProductExistInCart) {
              // Increase the quantity of the existing product in the cart
              cartRef.child(existingProductKey!).update({
                'quantity': cartItems![existingProductKey]['quantity'] + 1,
              });
            } else {
              // Add the product to the cart
              DatabaseReference productRef = cartRef.push();
              productRef.set({
                'name': productData!['name'],
                'price': productData!['price'],
                'quantity': 1,
              });
            }

            // Update the quantity of the product on the product detail page
            setState(() {
              productData!['quantity'] -= 1;
            });

            // Navigate to the cart page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          });
        } else {
          // Show an alert if the product is out of stock
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Out of Stock'),
                content: Text('This product is currently out of stock.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print('Error adding product to cart: $error');
    }
  }
}
