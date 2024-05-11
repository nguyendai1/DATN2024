// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_car/src/theme/theme.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import 'cart_page.dart';
// import 'edit_product.dart';
//
// class ProductDetailPage extends StatefulWidget {
//   final String productKey;
//   final bool isAdmin;
//
//   ProductDetailPage({required this.productKey, required this.isAdmin});
//
//   @override
//   _ProductDetailPageState createState() => _ProductDetailPageState();
// }
//
// class _ProductDetailPageState extends State<ProductDetailPage> {
//   late DatabaseReference _productsRef;
//   Map<dynamic, dynamic>? productData;
//   List<String>? imageUrls;
//   int _currentPageIndex = 0;
//   int _videoViews = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _productsRef = FirebaseDatabase.instance.ref().child('products');
//     _loadProductData();
//   }
//
//   void _loadProductData() {
//     _productsRef.child(widget.productKey).once().then((DatabaseEvent event) {
//       DataSnapshot snapshot = event.snapshot;
//       if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
//         Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
//         setState(() {
//           productData = data;
//           imageUrls = List<String>.from(data['imageUrls'] ?? []);
//         });
//
//         findSamePriceProducts();
//       }
//     }).catchError((error) {
//       print("Error loading product data: $error");
//     });
//   }
//
//   void _incrementVideoViews() {
//     setState(() {
//       _videoViews++;
//     });
//   }
//
//   List<Map<dynamic, dynamic>> samePriceProducts = [];
//
//   Future<void> findSamePriceProducts() async {
//     try {
//       double currentProductPrice = productData!['price'].toDouble();
//       DatabaseReference productRef = FirebaseDatabase.instance.ref().child('products');
//       DataSnapshot snapshot = await productRef.once().then((event) => event.snapshot);
//       Map<dynamic, dynamic>? products = snapshot.value as Map<dynamic, dynamic>?;
//       if (products != null) {
//         products.forEach((key, value) {
//           double price = value['price'].toDouble();
//           if (price == currentProductPrice && key != widget.productKey) {
//             setState(() {
//               samePriceProducts.add({...value, 'key': key});
//             });
//           }
//         });
//       }
//     } catch (error) {
//       print('Error finding same price products: $error');
//     }
//   }
//
//   Widget buildSamePriceProducts() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: samePriceProducts.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(samePriceProducts[index]['name']),
//               subtitle: Text('${samePriceProducts[index]['price']}tr VND'),
//               leading: Image.network(
//                 samePriceProducts[index]['imageUrls']?[0] ?? '',
//                 fit: BoxFit.cover,
//                 width: 60,
//                 height: 60,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailPage(productKey: samePriceProducts[index]['key'], isAdmin: widget.isAdmin,),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chi tiết sản phẩm', style: bold18White,),
//         backgroundColor: primaryColor,
//         actions: [
//           if (widget.isAdmin)
//             IconButton(
//               onPressed: () {
//                 _editProduct();
//               },
//               icon: Icon(Icons.edit),
//             ),
//         ],
//       ),
//       body: productData != null
//           ? SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               if (imageUrls != null && imageUrls!.isNotEmpty)
//                 Stack(
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       height: 200,
//                       child: PageView.builder(
//                         itemCount: imageUrls!.length,
//                         onPageChanged: (index) {
//                           setState(() {
//                             _currentPageIndex = index;
//                           });
//                         },
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               _showImageFullScreen(imageUrls![index]);
//                             },
//                             child: Hero(
//                               tag: 'product_image_${widget.productKey}_$index',
//                               child: Image.network(
//                                 imageUrls![index],
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 10,
//                       right: 10,
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.black54,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           '${_currentPageIndex + 1}/${imageUrls!.length}',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               Text('${productData!['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//               Text('${productData!['datePosted']}', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),),
//               Text('Giá: ${productData!['price']} tr VND', style: TextStyle(fontSize: 18),),
//               Text('Màu sắc: ${productData!['color']}', style: TextStyle(fontSize: 18),),
//               Text('Thương hiệu: ${productData!['brand']}', style: TextStyle(fontSize: 18),),
//               Text('Số lượng: ${productData!['quantity']}', style: TextStyle(fontSize: 18),),
//               Text('Tình trạng: ${productData!['status']}', style: TextStyle(fontSize: 18),),
//               Text('Mô tả: ${productData!['description']}', style: TextStyle(fontSize: 18),),
//               Container(
//                 height: 200, // Điều chỉnh chiều cao của video container tùy thích
//                 child: Stack(
//                   children: [
//                     WebView(
//                       initialUrl: productData!['videoUrl'],
//                       javascriptMode: JavascriptMode.unrestricted,
//                       onPageFinished: (String url) {
//                         _incrementVideoViews(); // Tăng số lượt xem khi trang web tải xong
//                       },
//                     ),
//                     Positioned(
//                       right: 16,
//                       top: 16,
//                       child: InkWell(
//                         onTap: () {
//                           _showFullScreenVideo(productData!['videoUrl']);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Icon(
//                             Icons.fullscreen,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       child: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.visibility, color: Colors.white),
//                             SizedBox(width: 4),
//                             Text(
//                               '$_videoViews',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (samePriceProducts.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: Text(
//                     'Các sản phẩm cùng giá:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               buildSamePriceProducts(),
//             ],
//           ),
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _addToCart();
//         },
//         child: Icon(Icons.add_shopping_cart),
//         backgroundColor: primaryColor,
//       ),
//     );
//   }
//
//   void _editProduct() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProductPage(productKey: widget.productKey),
//       ),
//     );
//   }
//
//   void _addToCart() {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('carts').child(auth.currentUser!.uid);
//
//     try {
//       if (productData != null) {
//         int quantity = productData!['quantity'];
//
//         if (quantity > 0) {
//           bool isProductExistInCart = false;
//           String? existingProductKey;
//
//           cartRef.once().then((DatabaseEvent event) {
//             DataSnapshot snapshot = event.snapshot;
//             Map<dynamic, dynamic>? cartItems = snapshot.value as Map?;
//
//             if (cartItems != null) {
//               cartItems.forEach((key, value) {
//                 if (value['name'] == productData!['name']) {
//                   existingProductKey = key;
//                   isProductExistInCart = true;
//                 }
//               });
//             }
//
//             if (isProductExistInCart) {
//               cartRef.child(existingProductKey!).update({
//                 'quantity': cartItems![existingProductKey]['quantity'] + 1,
//               });
//             } else {
//               DatabaseReference productRef = cartRef.push();
//               productRef.set({
//                 'name': productData!['name'],
//                 'price': productData!['price'],
//                 'quantity': 1,
//               });
//             }
//
//             setState(() {
//               productData!['quantity'] -= 1;
//             });
//
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CartPage(),
//               ),
//             );
//           });
//         } else {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Hết hàng'),
//                 content: Text('Sản phẩm này hiện đang hết hàng.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } catch (error) {
//       print('Lỗi thêm sản phẩm vào giỏ hàng: $error');
//     }
//   }
//
//   void _showImageFullScreen(String imageUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           backgroundColor: Colors.black,
//           body: Stack(
//             children: [
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Hero(
//                     tag: 'product_image_${widget.productKey}_$_currentPageIndex',
//                     child: PhotoView(
//                       imageProvider: NetworkImage(imageUrl),
//                       minScale: PhotoViewComputedScale.contained * 0.8, // Phóng to tối thiểu
//                       maxScale: PhotoViewComputedScale.covered * 2.0, // Phóng to tối đa
//                       initialScale: PhotoViewComputedScale.contained, // Tỷ lệ ban đầu
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: MediaQuery.of(context).padding.top,
//                 right: 0,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showFullScreenVideo(String videoUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text('Full Screen Video'),
//             backgroundColor: primaryColor,
//           ),
//           body: Center(
//             child: WebView(
//               initialUrl: videoUrl,
//               javascriptMode: JavascriptMode.unrestricted,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/theme/theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  int _currentPageIndex = 0;
  late int _videoViews;

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
          _videoViews = data['videoViews'] ?? 0; // Load số lượt xem từ Database
        });

        findSamePriceProducts();
      }
    }).catchError((error) {
      print("Error loading product data: $error");
    });
  }

  void _incrementVideoViews() {
    setState(() {
      _videoViews++;
    });
    _productsRef.child(widget.productKey).update({'videoViews': _videoViews}); // Lưu số lượt xem vào Database
  }

  List<Map<dynamic, dynamic>> samePriceProducts = [];

  Future<void> findSamePriceProducts() async {
    try {
      double currentProductPrice = productData!['price'].toDouble();
      DatabaseReference productRef = FirebaseDatabase.instance.ref().child('products');
      DataSnapshot snapshot = await productRef.once().then((event) => event.snapshot);
      Map<dynamic, dynamic>? products = snapshot.value as Map<dynamic, dynamic>?;
      if (products != null) {
        products.forEach((key, value) {
          double price = value['price'].toDouble();
          if (price == currentProductPrice && key != widget.productKey) {
            setState(() {
              samePriceProducts.add({...value, 'key': key});
            });
          }
        });
      }
    } catch (error) {
      print('Error finding same price products: $error');
    }
  }

  Widget buildSamePriceProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: samePriceProducts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(samePriceProducts[index]['name']),
              subtitle: Text('${samePriceProducts[index]['price']} tr VND'),
              leading: Image.network(
                samePriceProducts[index]['imageUrls']?[0] ?? '',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              onTap: () {
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
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: PageView.builder(
                        itemCount: imageUrls!.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showImageFullScreen(imageUrls![index]);
                            },
                            child: Hero(
                              tag: 'product_image_${widget.productKey}_$index',
                              child: Image.network(
                                imageUrls![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_currentPageIndex + 1}/${imageUrls!.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              Text('${productData!['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text('${productData!['datePosted']}', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),),
              Text('Giá: ${productData!['price']} tr VND', style: TextStyle(fontSize: 18),),
              Text('Màu sắc: ${productData!['color']}', style: TextStyle(fontSize: 18),),
              Text('Thương hiệu: ${productData!['brand']}', style: TextStyle(fontSize: 18),),
              Text('Số lượng: ${productData!['quantity']}', style: TextStyle(fontSize: 18),),
              Text('Tình trạng: ${productData!['status']}', style: TextStyle(fontSize: 18),),
              Text('Mô tả: ${productData!['description']}', style: TextStyle(fontSize: 18),),
              Container(
                height: 200, // Điều chỉnh chiều cao của video container tùy thích
                child: Stack(
                  children: [
                    WebView(
                      initialUrl: productData!['videoUrl'],
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (String url) {
                        _incrementVideoViews(); // Tăng số lượt xem khi trang web tải xong
                      },
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: InkWell(
                        onTap: () {
                          _showFullScreenVideo(productData!['videoUrl']);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.visibility, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              '$_videoViews',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (samePriceProducts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Các sản phẩm cùng giá:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
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
              cartRef.child(existingProductKey!).update({
                'quantity': cartItems![existingProductKey]['quantity'] + 1,
              });
            } else {
              DatabaseReference productRef = cartRef.push();
              productRef.set({
                'name': productData!['name'],
                'price': productData!['price'],
                'quantity': 1,
              });
            }

            setState(() {
              productData!['quantity'] -= 1;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Hết hàng'),
                content: Text('Sản phẩm này hiện đang hết hàng.'),
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
      print('Lỗi thêm sản phẩm vào giỏ hàng: $error');
    }
  }

  void _showImageFullScreen(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Hero(
                    tag: 'product_image_${widget.productKey}_$_currentPageIndex',
                    child: PhotoView(
                      imageProvider: NetworkImage(imageUrl),
                      minScale: PhotoViewComputedScale.contained * 0.8, // Phóng to tối thiểu
                      maxScale: PhotoViewComputedScale.covered * 2.0, // Phóng to tối đa
                      initialScale: PhotoViewComputedScale.contained, // Tỷ lệ ban đầu
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenVideo(String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Full Screen Video'),
            backgroundColor: primaryColor,
          ),
          body: Center(
            child: WebView(
              initialUrl: videoUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
      ),
    );
  }
}
