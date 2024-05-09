import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liên hệ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZaloWebView()),
                );
              },
              icon: Icon(Icons.chat),
              label: Text(
                'Zalo',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacebookWebView()),
                );
              },
              icon: Icon(Icons.facebook),
              label: Text(
                'Facebook',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZaloWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zalo'),
      ),
      body: WebView(
        initialUrl: 'https://chat.zalo.me/',
        // initialUrl: 'https://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder',
      ),
    );
  }
}

class FacebookWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook'),
      ),
      body: WebView(
        initialUrl: 'https://m.facebook.com/profile.php?id=61559047570633/',
        // initialUrl: 'https://sandbox.vnpayment.vn/tryitnow/Home/CreateOrder',
      ),
    );
  }
}
