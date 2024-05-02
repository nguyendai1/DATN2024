import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/resources/login_page.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'blocs/auth_bloc.dart';

class MyApp extends InheritedWidget {
  final AuthBloc authBloc;

  MyApp({required this.authBloc, required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static MyApp? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
