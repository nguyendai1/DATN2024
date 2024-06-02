import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        title: Text('Thanh toán', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_nameController, 'Tên'),
            SizedBox(height: 10),
            _buildTextField(_phoneController, 'Số điện thoại', keyboardType: TextInputType.phone),
            SizedBox(height: 10),
            _buildTextField(_addressController, 'Địa chỉ giao hàng'),
            SizedBox(height: 20),
            _buildPaymentButton('VNPay', 'Thanh toán qua VNPay'),
            SizedBox(height: 10),
            _buildPaymentButton('Momo', 'Thanh toán qua Momo'),
            SizedBox(height: 10),
            _buildPaymentButton1('Thanh toán khi nhận hàng', 'Thanh toán khi nhận hàng'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPaymentButton(String paymentMethod, String buttonText) {
    return ElevatedButton(
      onPressed: () {
        _handlePaymentSelection(context, paymentMethod);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(buttonText),
    );
  }

  Future<void> _handlePaymentSelection(BuildContext context, String paymentMethod) async {
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

      _showPaymentSuccessDialog(context, paymentMethod, address);
    } else {
      _showMissingInformationDialog(context);
    }
  }

  void _showPaymentSuccessDialog(BuildContext context, String paymentMethod, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Phương thức thanh toán đã chọn'),
          content: Text('Bạn đã chọn $paymentMethod. Đơn hàng của bạn sẽ được giao tới $address.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PayWebView()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMissingInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông tin còn thiếu'),
          content: Text('Vui lòng điền đầy đủ thông tin.'),
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

  Widget _buildPaymentButton1(String paymentMethod, String buttonText) {
    return ElevatedButton(
      onPressed: () {
        _handlePaymentSelection1(context, paymentMethod);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(buttonText),
    );
  }

  Future<void> _handlePaymentSelection1(BuildContext context, String paymentMethod) async {
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

      _showPaymentSuccessDialog1(context, paymentMethod, address);
    } else {
      _showMissingInformationDialog(context);
    }
  }

  void _showPaymentSuccessDialog1(BuildContext context, String paymentMethod, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Phương thức thanh toán đã chọn'),
          content: Text('Bạn đã chọn $paymentMethod. Đơn hàng của bạn sẽ được giao tới $address.'),
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class PayWebView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: WebView(
        initialUrl: 'https://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder',
        userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.3538.77 Mobile Safari/537.36',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

