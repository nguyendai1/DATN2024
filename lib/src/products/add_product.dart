import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../theme/theme.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final DatabaseReference _productRef = FirebaseDatabase.instance.ref().child('products');
  List<Map<dynamic, dynamic>> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sản phẩm mới', style: bold18White),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'ImageUrls'),
              maxLines: null,
              minLines: 3,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Tình trạng'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Màu sắc'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Thương hiệu'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addProduct();
              },
              child: Text('Lưu'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
    String name = _nameController.text.trim();
    List<String> imageUrls = _imageUrlController.text.trim().split(',');
    double price = double.parse(_priceController.text.trim());
    String status = _statusController.text.trim();
    String description = _descriptionController.text.trim();
    String color = _colorController.text.trim();
    String brand = _brandController.text.trim();
    int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    if (name.isNotEmpty &&
        imageUrls.isNotEmpty &&
        status.isNotEmpty &&
        description.isNotEmpty &&
        color.isNotEmpty &&
        brand.isNotEmpty) {
      Map<String, dynamic> productData = {
        'name': name,
        'imageUrls': imageUrls,
        'price': price,
        'status': status,
        'description': description,
        'color': color,
        'brand': brand,
        'quantity': quantity,
      };

      _productRef.push().set(productData).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thành công'),
              content: Text('Thêm sản phẩm thành công.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print("Thêm sản phẩm thất bại: $error");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin.'),
        ),
      );
    }
  }

  void fetchProducts() async {
    _productRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot != null && snapshot.value != null) {
        setState(() {
          _products.clear();
          Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            _products.add(value);
          });
        });
      }
    }).catchError((error) {
      print("Lỗi khi lấy dữ liệu: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
}
