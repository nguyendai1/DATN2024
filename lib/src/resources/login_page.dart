import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/resources/forgotpassword_page.dart';
import 'package:flutter_app_car/src/resources/register_page.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

import '../app.dart';
import '../blocs/auth_bloc.dart';
import 'dialog/loading_dialog.dart';
import 'dialog/msg_dialog.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 140,
              ),
              Image.asset('assets/icons/ic_car_green.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                child: Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Text(
                "Login to continue using iCab",
                style: TextStyle(fontSize: 16, color: Color(0xff606470)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 145, 0, 20),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Container(
                      width: 50,
                      child: Image.asset('assets/icons/ic_mail.png'),
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xffCED0D2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _passController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Container(
                    width: 50,
                    child: Image.asset('assets/icons/ic_lock.png'),
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints.loose(Size(double.infinity, 50)),
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ForgotPasswordPage())
                      );
                    },
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onLoginClick,
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: RichText(
                  text: TextSpan(
                      text: "New user?",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => const RegisterPage())
                                );
                              },
                            text: "Sign up for a new account",
                            style: const TextStyle(color: Color(0xff3277D8),
                                fontSize: 16)
                        )
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoginClick() {
    String email = _emailController.text;
    String pass = _passController.text;
    var authBloc = MyApp.of(context)?.authBloc;
    LoadingDialog.showLoadingDialog(context, "Loading...");
    authBloc?.signIn(email, pass, () {
      LoadingDialog.hideLoadingDialog(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Sign-In", msg);
    } );
  }

}