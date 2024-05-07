import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

class OrdersFromStatisticsPage extends StatefulWidget {
  @override
  _OrdersFromStatisticsPageState createState() => _OrdersFromStatisticsPageState();
}

class _OrdersFromStatisticsPageState extends State<OrdersFromStatisticsPage> {
  List<Map<dynamic, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      DatabaseReference statisticsRef = FirebaseDatabase.instance.ref().child('transactions');
      statisticsRef.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> fetchedTransactions = [];
          data.forEach((key, value) {
            value['key'] = key; // Add the transaction key to the map
            fetchedTransactions.add(value);
          });
          setState(() {
            transactions = fetchedTransactions;
          });
        }
      });
    } catch (error) {
      print('Error fetching transactions from statistics: $error');
    }
  }

  Future<void> _deleteTransaction(String transactionKey) async {
    try {
      DatabaseReference statisticsRef = FirebaseDatabase.instance.ref().child('transactions');
      statisticsRef.child(transactionKey).remove().then((_) {
        setState(() {
          transactions.removeWhere((transaction) => transaction['key'] == transactionKey);
        });
      });
    } catch (error) {
      print('Error deleting transaction: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng', style: bold18White,),
        backgroundColor: primaryColor,
      ),
      body: transactions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: transactions.length * 2 - 1,
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
                'Tên: ${transactions[realIndex]['name']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Địa chỉ: ${transactions[realIndex]['address']}'),
                  Text('Số điện thoại: ${transactions[realIndex]['phone']}'),
                  Text(
                    'Số tiền: ${transactions[realIndex]['amount']}tr VND',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteTransaction(transactions[realIndex]['key']),
              ),
            ),
          );
        },
      ),
    );
  }
}
