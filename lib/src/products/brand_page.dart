import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/products/product_detail_page.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class ProductBrandPage extends StatefulWidget {
  @override
  _ProductBrandPageState createState() => _ProductBrandPageState();
}

class _ProductBrandPageState extends State<ProductBrandPage> {
  late DatabaseReference _productsRef;
  Map<String, List<Map<dynamic, dynamic>>> brandProducts = {};
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsRef = FirebaseDatabase.instance.ref().child('products');
    _loadProductBrands();
  }

  void _loadProductBrands() async {
    DataSnapshot snapshot = await _productsRef.once().then((event) => event.snapshot);
    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        String brand = value['brand'];
        if (brandProducts.containsKey(brand)) {
          brandProducts[brand]!.add({...value, 'key': key});
        } else {
          brandProducts[brand] = [{...value, 'key': key}];
        }
      });
      setState(() {});
    }
  }

  List<String> get filteredBrands {
    final query = _searchController.text.toLowerCase();
    return brandProducts.keys.where((brand) => brand.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục thương hiệu', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thương hiệu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          if (_searchController.text.isNotEmpty && filteredBrands.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Không tìm thấy thương hiệu phù hợp.'),
            ),
          if (filteredBrands.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredBrands.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return Divider(
                      color: Colors.grey,
                      height: 1,
                    );
                  }
                  final realIndex = index ~/ 2;
                  String brand = filteredBrands[realIndex];
                  return Column(
                    children: [
                      Container(
                        color: realIndex % 2 == 0 ? Colors.white : Colors.grey[200],
                        child: ListTile(
                          title: Text(brand),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrandDetailPage(brand: brand, products: brandProducts[brand]!),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class BrandDetailPage extends StatelessWidget {
  final String brand;
  final List<Map<dynamic, dynamic>> products;

  BrandDetailPage({required this.brand, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          Map<dynamic, dynamic> product = products[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productKey: product['key'],
                    isAdmin: false,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    height: 90,// Adjust the height of the image container as needed
                    child: Image.network(
                      product['imageUrls']?[0] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      product['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Giá: ${product['price']} VND',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
