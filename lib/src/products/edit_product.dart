import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final Map<dynamic, dynamic> product;

  EditProductPage({required this.product});

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
    _nameController = TextEditingController(text: widget.product['name']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _colorController = TextEditingController(text: widget.product['color']);
    _brandController = TextEditingController(text: widget.product['brand']);
    _quantityController = TextEditingController(text: widget.product['quantity'].toString());
    _statusController = TextEditingController(text: widget.product['status']);
    _descriptionController = TextEditingController(text: widget.product['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView( // Đặt SingleChildScrollView ở đây
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateProduct();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProduct() {
    String newName = _nameController.text.trim();
    double newPrice = double.parse(_priceController.text.trim());
    String newColor = _colorController.text.trim();
    String newBrand = _brandController.text.trim();
    int newQuantity = int.parse(_quantityController.text.trim());
    String newStatus = _statusController.text.trim();
    String newDescription = _descriptionController.text.trim();

    // Thực hiện cập nhật thông tin sản phẩm lên Firebase
    _productsRef.child(widget.product['key']).update({
      'name': newName,
      'price': newPrice,
      'color': newColor,
      'brand': newBrand,
      'quantity': newQuantity,
      'status': newStatus,
      'description': newDescription,
    }).then((_) {
      // Cập nhật thành công, quay lại trang trước đó
      Navigator.pop(context as BuildContext);
    }).catchError((error) {
      // Xử lý lỗi nếu có
      print('Error updating product: $error');
    });
  }
}
