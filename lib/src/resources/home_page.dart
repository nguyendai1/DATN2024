import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/resources/widgets/home_menu.dart';

import '../products/add_product.dart';
import '../products/cart_page.dart';
import '../products/product_detail_page.dart';
import '../theme/theme.dart';
import '../fire_base/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _productRef = FirebaseDatabase.instance.ref().child('products');
  List<Map<dynamic, dynamic>> _products = [];
  String _searchKeyword = '';
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkUserRole();
    fetchProducts();
  }

  Future<void> checkUserRole() async {
    bool userIsAdmin = await AuthService().checkUserRole();
    setState(() {
      isAdmin = userIsAdmin;
    });
  }

  Future<void> fetchProducts() async {
    _productRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot != null && snapshot.value != null) {
        setState(() {
          _products.clear();
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            Map<dynamic, dynamic> product = value;
            product['key'] = key; // Thêm key của sản phẩm vào Map
            _products.add(product);
          });
        });
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Sản phẩm",
          style: bold18White,
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              _navigateToCartPage();
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchProducts();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 3.5,
                ),
                itemCount: _products
                    .where((product) =>
                _searchKeyword.isEmpty ||
                    product['name']
                        .toString()
                        .toLowerCase()
                        .contains(_searchKeyword))
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  final filteredProducts = _products
                      .where((product) =>
                  _searchKeyword.isEmpty ||
                      product['name']
                          .toString()
                          .toLowerCase()
                          .contains(_searchKeyword))
                      .toList();
                  filteredProducts.sort((a, b) {
                    if (a['name']
                        .toString()
                        .toLowerCase()
                        .contains(_searchKeyword) &&
                        !b['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchKeyword)) {
                      return -1;
                    } else if (!a['name']
                        .toString()
                        .toLowerCase()
                        .contains(_searchKeyword) &&
                        b['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchKeyword)) {
                      return 1;
                    } else {
                      return 0;
                    }
                  });

                  bool hasImage =
                      filteredProducts[index]['imageUrls'] != null;

                  return GestureDetector(
                    onTap: () {
                      final productKey = filteredProducts[index]['key'];
                      if (productKey != null) {
                        _showProductDetail(context, productKey);
                      } else {
                        print('Product key is null');
                      }
                    },
                    child: Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 110,
                            child: hasImage
                                ? Image.network(
                              filteredProducts[index]['imageUrls'][0],
                              fit: BoxFit.cover,
                            )
                                : Center(child: Text('No Image')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filteredProducts[index]['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Giá: ${filteredProducts[index]['price'].toStringAsFixed(0)}tr VND',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(isAdmin: isAdmin),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () {
          _goToAddProductPage();
        },
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      )
          : null,
    );
  }

  void _showProductDetail(BuildContext context, String productKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(productKey: productKey, isAdmin: isAdmin,),
      ),
    );
  }

  void _goToAddProductPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(),
      ),
    );
  }

  void _navigateToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(),
      ),
    );
  }
}
