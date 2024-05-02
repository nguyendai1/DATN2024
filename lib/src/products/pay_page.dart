import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PaymentTransaction {
  final String paymentMethod;
  final double amount;
  final DateTime timestamp;

  PaymentTransaction({
    required this.paymentMethod,
    required this.amount,
    required this.timestamp,
  });
}

class PaymentPage extends StatefulWidget {
  final double totalPrice;

  PaymentPage({required this.totalPrice});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Delivery Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handlePaymentSelection(context, 'VNPay');
              },
              child: Text('Pay with VNPay'),
            ),
            ElevatedButton(
              onPressed: () {
                _handlePaymentSelection(context, 'Momo');
              },
              child: Text('Pay with Momo'),
            ),
            ElevatedButton(
              onPressed: () {
                _handlePaymentSelection(context, 'Cash on Delivery');
              },
              child: Text('Cash on Delivery'),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSelection(BuildContext context, String paymentMethod) {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();

    if (name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty) {
      PaymentTransaction transaction = PaymentTransaction(
        paymentMethod: paymentMethod,
        amount: widget.totalPrice,
        timestamp: DateTime.now(),
      );

      DatabaseReference transactionsRef = FirebaseDatabase.instance.ref().child('transactions');
      transactionsRef.push().set({
        'name': name,
        'phone': phone,
        'address': address,
        'paymentMethod': transaction.paymentMethod,
        'amount': transaction.amount,
        'timestamp': transaction.timestamp.toUtc().toString(),
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Method Selected'),
            content: Text('You have selected $paymentMethod. Your order will be delivered to $address.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please fill in all the fields.'),
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
