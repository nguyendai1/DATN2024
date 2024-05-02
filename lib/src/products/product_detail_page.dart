import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../fire_base/auth_service.dart';
import 'cart_page.dart';
import 'delete_product.dart';
import 'edit_product.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<dynamic, dynamic> product;
  const ProductDetailPage({Key? key, required this.product,}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isAdmin = false;
  List<Map<dynamic, dynamic>> cartItems = [];
  List<Map<dynamic, dynamic>> _products = [];
  List<Map<dynamic, dynamic>> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    checkUserRole(); // Kiểm tra vai trò của người dùng khi trang được tạo
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    // Lấy danh sách sản phẩm từ giỏ hàng (hoặc cơ sở dữ liệu khác)
    // Ví dụ:
    // cartItems = await CartService().getCartItems();
  }

  Future<void> checkUserRole() async {
    // Lấy thông tin về vai trò của người dùng từ AuthService
    bool userIsAdmin = await AuthService().checkUserRole();
    setState(() {
      isAdmin = userIsAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
        actions: [
          if (isAdmin) // Hiển thị nút chỉnh sửa và xóa chỉ khi isAdmin là true
            IconButton(
              onPressed: () {
                // Thực hiện hành động khi nhấn nút chỉnh sửa
                _editProduct(widget.product);
              },
              icon: Icon(Icons.edit),
            ),
          if (isAdmin)
            IconButton(
              onPressed: () {
                // Thực hiện hành động khi nhấn nút xóa
                _deleteProduct(widget.product);
              },
              icon: Icon(Icons.delete),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    if (widget.product['imageUrl'] != null)
                      Image.network(
                        widget.product['imageUrl'],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${widget.product['name']}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Price: \$${widget.product['price'].toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Color: ${widget.product['color']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Brand: ${widget.product['brand']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Quantity: ${widget.product['quantity']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Status: ${widget.product['status']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Description: ${widget.product['description']}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                _addToCart(widget.product, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Màu nền của nút
                minimumSize: Size(300, 50), // Kích thước tối thiểu của nút
                padding: EdgeInsets.symmetric(vertical: 15), // Khoảng cách nội dung và viền nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Độ cong của góc nút
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Màu chữ của nút
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(Map<dynamic, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  void _deleteProduct(Map<dynamic, dynamic> product) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeleteProductPage(product: widget.product),
        ),
      );
  }

  void _addToCart(Map<dynamic, dynamic> product, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('carts').child(auth.currentUser!.uid);

    try {
      int quantity = product['quantity'];

      if (quantity > 0) {
        bool isProductExistInCart = false;
        String? existingProductKey;

        DatabaseEvent event = await cartRef.once();
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? cartItems = snapshot.value as Map?;

        if (cartItems != null) {
          cartItems.forEach((key, value) {
            if (value['name'] == product['name']) {
              existingProductKey = key;
              isProductExistInCart = true;
            }
          });
        }

        if (isProductExistInCart) {
          // Giảm số lượng sản phẩm trong cơ sở dữ liệu đi 1
            cartRef.child(existingProductKey!).update({
            'quantity': cartItems![existingProductKey]['quantity'] + 1,
          });

          // Giảm số lượng sản phẩm trên trang chi tiết đi 1
          setState(() {
            widget.product['quantity'] -= 1;
          });
        } else {
          DatabaseReference productRef = cartRef.push();
          productRef.set({
            'name': product['name'],
            'price': product['price'],
            'quantity': 1,
          });
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        );
      } else {
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
    } catch (error) {
      print('Error adding product to cart: $error');
    }
  }
}
