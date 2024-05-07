import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class EditProductPage extends StatefulWidget {
  final String productKey;

  EditProductPage({required this.productKey});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _colorController;
  late TextEditingController _brandController;
  late TextEditingController _quantityController;
  late TextEditingController _statusController;
  late TextEditingController _descriptionController;

  DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _colorController = TextEditingController();
    _brandController = TextEditingController();
    _quantityController = TextEditingController();
    _statusController = TextEditingController();
    _descriptionController = TextEditingController();

    _loadProductData(widget.productKey);
  }

  void _loadProductData(String productKey) {
    _productsRef.child(productKey).once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? productData = snapshot.value as Map<dynamic, dynamic>?;

        if (productData != null) {
          setState(() {
            _nameController.text = productData['name'] ?? '';
            _priceController.text = productData['price']?.toString() ?? '';
            _colorController.text = productData['color'] ?? '';
            _brandController.text = productData['brand'] ?? '';
            _quantityController.text = productData['quantity']?.toString() ?? '';
            _statusController.text = productData['status'] ?? '';
            _descriptionController.text = productData['description'] ?? '';
          });
        }
      }
    }).catchError((error) {
      print('Error loading product data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa sản phẩm', style: TextStyle(fontSize: 18)),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Màu sắc'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Thương hiệu'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Tình trạng'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateProduct();
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProduct() {
    String newName = _nameController.text.trim();
    double newPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
    String newColor = _colorController.text.trim();
    String newBrand = _brandController.text.trim();
    int newQuantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    String newStatus = _statusController.text.trim();
    String newDescription = _descriptionController.text.trim();

    _productsRef.child(widget.productKey).update({
      'name': newName,
      'price': newPrice,
      'color': newColor,
      'brand': newBrand,
      'quantity': newQuantity,
      'status': newStatus,
      'description': newDescription,
    }).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      print('Error updating product: $error');
    });
  }
}
