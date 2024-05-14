import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

import 'add_product.dart';

class ProductManagementPage extends StatefulWidget {
  @override
  _ProductManagementPageState createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  List<Map<dynamic, dynamic>> products = [];
  List<Map<dynamic, dynamic>> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      DatabaseReference productsRef = FirebaseDatabase.instance.ref().child('products');
      productsRef.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> fetchedProducts = [];
          data.forEach((key, value) {
            value['key'] = key; // Add the transaction key to the map
            fetchedProducts.add(value);
          });
          setState(() {
            products = fetchedProducts;
            filteredProducts = fetchedProducts;
          });
        }
      });
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  Future<void> _deleteProduct(String productKey) async {
    try {
      DatabaseReference productsRef = FirebaseDatabase.instance.ref().child('products');
      productsRef.child(productKey).remove().then((_) {
        setState(() {
          products.removeWhere((product) => product['key'] == productKey);
          _filterProducts();
        });
      });
    } catch (error) {
      print('Error deleting product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý xe', style: bold18White),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredProducts.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(
                    color: Colors.grey,
                    height: 1,
                  );
                }
                final realIndex = index ~/ 2;
                return Container(
                  color: realIndex % 2 == 0 ? Colors.white : Colors.grey[200],
                  child: ListTile(
                    title: Text(
                      '${filteredProducts[realIndex]['name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá bán: ${filteredProducts[realIndex]['price']} tr VND',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(filteredProducts[realIndex]['key']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProductPage,
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
