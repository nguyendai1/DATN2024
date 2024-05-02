import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String paymentMethod;
  final double amount;
  final DateTime timestamp;

  Transaction({
    required this.paymentMethod,
    required this.amount,
    required this.timestamp,
  });
}

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final DatabaseReference transactionsRef =
  FirebaseDatabase.instance.ref().child('transactions');

  List<Transaction> transactions = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String selectedMonth = 'January'; // Default selection

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      // Listen for changes in the transactions node
      transactionsRef.onValue.listen((event) {
        List<Transaction> updatedTransactions = [];
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> transactionsData =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          transactionsData.forEach((key, value) {
            Transaction transaction = Transaction(
              paymentMethod: value['paymentMethod'],
              amount: double.parse(value['amount'].toString()),
              timestamp: DateTime.parse(value['timestamp']),
            );
            updatedTransactions.add(transaction);
          });
          setState(() {
            transactions = updatedTransactions;
          });
        }
      });
    } catch (error) {
      print('Error fetching statistics: $error');
    }
  }

  List<Transaction> filterTransactionsByMonth(String month) {
    return transactions.where((transaction) {
      return transaction.timestamp.month == months.indexOf(month) + 1;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int totalTransactions = filterTransactionsByMonth(selectedMonth).length;
    double totalRevenue = _calculateTotalRevenue();
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? month) {
                setState(() {
                  selectedMonth = month!;
                });
              },
              items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Total Items Sold: $totalTransactions',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount Earned: \$${totalRevenue.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Transactions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filterTransactionsByMonth(selectedMonth).length,
                itemBuilder: (context, index) {
                  final transaction = filterTransactionsByMonth(selectedMonth)[index];
                  return ListTile(
                    title: Text('Payment Method: ${transaction.paymentMethod}'),
                    subtitle: Text('Amount: \$${transaction.amount.toStringAsFixed(2)}\nTime: ${transaction.timestamp.toString()}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalRevenue() {
    double totalRevenue = 0;
    List<Transaction> filteredTransactions = filterTransactionsByMonth(selectedMonth);
    for (var transaction in filteredTransactions) {
      totalRevenue += transaction.amount;
    }
    return totalRevenue;
  }
}
