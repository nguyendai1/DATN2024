// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// import '../theme/theme.dart';
//
// class Transaction {
//   final String paymentMethod;
//   final double amount;
//   final DateTime timestamp;
//
//   Transaction({
//     required this.paymentMethod,
//     required this.amount,
//     required this.timestamp,
//   });
// }
//
// class StatisticsPage extends StatefulWidget {
//   @override
//   _StatisticsPageState createState() => _StatisticsPageState();
// }
//
// class _StatisticsPageState extends State<StatisticsPage> {
//   final DatabaseReference transactionsRef =
//   FirebaseDatabase.instance.ref().child('transactions');
//
//   List<Transaction> transactions = [];
//   List<String> months = [
//     'Tháng 1',
//     'Tháng 2',
//     'Tháng 3',
//     'Tháng 4',
//     'Tháng 5',
//     'Tháng 6',
//     'Tháng 7',
//     'Tháng 8',
//     'Tháng 9',
//     'Tháng 10',
//     'Tháng 11',
//     'Tháng 12'
//   ];
//   String selectedMonth = 'Tháng 1'; // Default selection
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStatistics();
//   }
//
//   Future<void> fetchStatistics() async {
//     try {
//       transactionsRef.onValue.listen((event) {
//         List<Transaction> updatedTransactions = [];
//         if (event.snapshot.value != null) {
//           Map<dynamic, dynamic> transactionsData =
//           Map<dynamic, dynamic>.from(event.snapshot.value as Map);
//           transactionsData.forEach((key, value) {
//             Transaction transaction = Transaction(
//               paymentMethod: value['paymentMethod'],
//               amount: double.parse(value['amount'].toString()),
//               timestamp: DateTime.parse(value['timestamp']),
//             );
//             updatedTransactions.add(transaction);
//           });
//           setState(() {
//             transactions = updatedTransactions;
//           });
//         }
//       });
//     } catch (error) {
//       print('Error fetching statistics: $error');
//     }
//   }
//
//   List<Transaction> filterTransactionsByMonth(String month) {
//     return transactions.where((transaction) {
//       return transaction.timestamp.month == months.indexOf(month) + 1;
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int totalTransactions = filterTransactionsByMonth(selectedMonth).length;
//     double totalRevenue = _calculateTotalRevenue();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thống kê',style: bold18White,),
//         backgroundColor: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               DropdownButton<String>(
//                 value: selectedMonth,
//                 onChanged: (String? month) {
//                   setState(() {
//                     selectedMonth = month!;
//                   });
//                 },
//                 items: months.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 20),
//               _buildBarChart(), // Đặt biểu đồ trước danh sách đơn hàng
//               SizedBox(height: 20),
//               Text(
//                 'Đơn hàng đã bán: $totalTransactions',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'Tổng tiền: ${totalRevenue.toStringAsFixed(0)}tr VND',
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Danh sách đơn hàng đã bán:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: filterTransactionsByMonth(selectedMonth).length,
//                 itemBuilder: (context, index) {
//                   final transaction =
//                   filterTransactionsByMonth(selectedMonth)[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
//                     elevation: 2,
//                     child: ListTile(
//                       title: Text(
//                           'Phương thức thanh toán: ${transaction.paymentMethod}'),
//                       subtitle: Text(
//                           'Số tiền: ${transaction.amount.toStringAsFixed(0)}tr VND\nNgày: ${transaction.timestamp.toString()}'),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBarChart() {
//     List<Transaction> filteredTransactions =
//     filterTransactionsByMonth(selectedMonth);
//
//     // Tạo một Map để lưu trữ tổng số tiền cho mỗi phương thức thanh toán
//     Map<String, double> paymentAmounts = {};
//
//     // Tính tổng số tiền cho mỗi phương thức thanh toán
//     for (var transaction in filteredTransactions) {
//       if (!paymentAmounts.containsKey(transaction.paymentMethod)) {
//         paymentAmounts[transaction.paymentMethod] = transaction.amount;
//       } else {
//         paymentAmounts[transaction.paymentMethod] =
//             (paymentAmounts[transaction.paymentMethod] ?? 0) + transaction.amount;
//       }
//     }
//
//     // Tạo danh sách series từ Map
//     List<charts.Series<dynamic, String>> seriesList = [];
//     paymentAmounts.forEach((paymentMethod, amount) {
//       seriesList.add(
//         charts.Series(
//           id: paymentMethod,
//           data: [
//             Transaction(
//                 paymentMethod: paymentMethod,
//                 amount: amount,
//                 timestamp: DateTime.now())
//           ], // Thêm một Transaction giả mạo với tổng số tiền cho mỗi phương thức thanh toán
//           domainFn: (dynamic transaction, _) => paymentMethod,
//           measureFn: (dynamic transaction, _) => amount,
//           colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//           labelAccessorFn: (_, __) => '${amount.toStringAsFixed(0)} tr VND',
//         ),
//       );
//     });
//
//     return Container(
//       height: 300,
//       padding: EdgeInsets.all(20),
//       child: charts.BarChart(
//         seriesList,
//         animate: true,
//         vertical: true,
//         barRendererDecorator: charts.BarLabelDecorator<String>(),
//         domainAxis: charts.OrdinalAxisSpec(
//           renderSpec: charts.SmallTickRendererSpec(
//             labelRotation: 60,
//             labelOffsetFromAxisPx: 12,
//           ),
//         ),
//       ),
//     );
//   }
//
//   double _calculateTotalRevenue() {
//     double totalRevenue = 0;
//     List<Transaction> filteredTransactions =
//     filterTransactionsByMonth(selectedMonth);
//     for (var transaction in filteredTransactions) {
//       totalRevenue += transaction.amount;
//     }
//     return totalRevenue;
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../theme/theme.dart';

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
    'Tháng 1',
    'Tháng 2',
    'Tháng 3',
    'Tháng 4',
    'Tháng 5',
    'Tháng 6',
    'Tháng 7',
    'Tháng 8',
    'Tháng 9',
    'Tháng 10',
    'Tháng 11',
    'Tháng 12'
  ];
  String selectedMonth = 'Tháng 1'; // Default selection

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
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
        title: Text(
          'Thống kê',
          style: bold18White,
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              _buildBarChart(),
              SizedBox(height: 20),
              Text(
                'Đơn hàng đã bán: $totalTransactions',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Tổng tiền: ${totalRevenue.toStringAsFixed(0)} tr VND',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Danh sách đơn hàng đã bán:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filterTransactionsByMonth(selectedMonth).length,
                itemBuilder: (context, index) {
                  final transaction =
                  filterTransactionsByMonth(selectedMonth)[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                          'Phương thức thanh toán: ${transaction.paymentMethod}'),
                      subtitle: Text(
                          'Số tiền: ${transaction.amount.toStringAsFixed(0)} tr VND\nNgày: ${transaction.timestamp.toLocal().toString()}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    List<Transaction> filteredTransactions =
    filterTransactionsByMonth(selectedMonth);

    Map<String, double> paymentAmounts = {};

    for (var transaction in filteredTransactions) {
      if (!paymentAmounts.containsKey(transaction.paymentMethod)) {
        paymentAmounts[transaction.paymentMethod] = transaction.amount;
      } else {
        paymentAmounts[transaction.paymentMethod] =
            (paymentAmounts[transaction.paymentMethod] ?? 0) + transaction.amount;
      }
    }

    List<charts.Series<dynamic, String>> seriesList = [];
    paymentAmounts.forEach((paymentMethod, amount) {
      seriesList.add(
        charts.Series(
          id: paymentMethod,
          data: [
            Transaction(
                paymentMethod: paymentMethod,
                amount: amount,
                timestamp: DateTime.now().toLocal())
          ], // Thêm một Transaction giả mạo với tổng số tiền cho mỗi phương thức thanh toán
          domainFn: (dynamic transaction, _) => paymentMethod,
          measureFn: (dynamic transaction, _) => amount,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          labelAccessorFn: (_, __) => '${amount.toStringAsFixed(0)} tr VND',
        ),
      );
    });

    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: charts.BarChart(
        seriesList,
        animate: true,
        vertical: true,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
            labelRotation: 60,
            labelOffsetFromAxisPx: 12,
          ),
        ),
      ),
    );
  }

  double _calculateTotalRevenue() {
    double totalRevenue = 0;
    List<Transaction> filteredTransactions =
    filterTransactionsByMonth(selectedMonth);
    for (var transaction in filteredTransactions) {
      totalRevenue += transaction.amount;
    }
    return totalRevenue;
  }
}
