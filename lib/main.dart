import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/firebase_options.dart';
import 'package:flutter_app_car/src/app.dart';
import 'package:flutter_app_car/src/blocs/auth_bloc.dart';
import 'package:flutter_app_car/src/resources/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setLanguageCode('vi');
  runApp(MyApp(
    authBloc: AuthBloc(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  ));
}

