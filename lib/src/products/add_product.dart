import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  final TextEditingController _brandController = TextEditingController(); // New field for brand name
  final TextEditingController _quantityController = TextEditingController(); // New field for quantity

  final DatabaseReference _productRef = FirebaseDatabase.instance.ref().child('products');
  List<Map<dynamic, dynamic>> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: _brandController, // New field for brand name
                decoration: InputDecoration(labelText: 'Brand Name'),
              ),
              TextField(
                controller: _quantityController, // New field for quantity
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addProduct();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() {
    String name = _nameController.text.trim();
    String imageUrl = _imageUrlController.text.trim();
    double price = double.parse(_priceController.text.trim());
    String status = _statusController.text.trim();
    String description = _descriptionController.text.trim();
    String color = _colorController.text.trim();
    String brand = _brandController.text.trim(); // Retrieve brand name
    int quantity = int.tryParse(_quantityController.text.trim()) ?? 0; // Retrieve quantity

    if (name.isNotEmpty &&
        imageUrl.isNotEmpty &&
        status.isNotEmpty &&
        description.isNotEmpty &&
        color.isNotEmpty &&
        brand.isNotEmpty) {
      Map<String, dynamic> productData = {
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'status': status,
        'description': description,
        'color': color,
        'brand': brand, // Add brand name to product data
        'quantity': quantity, // Add quantity to product data
      };

      _productRef.push().set(productData).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Product added successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    fetchProducts();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        print("Failed to add product: $error");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
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
      print("Error fetching data: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
}
