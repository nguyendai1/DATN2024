import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_car/src/resources/dialog/loading_dialog.dart';
import 'package:flutter_app_car/src/resources/dialog/msg_dialog.dart';
import 'package:flutter_app_car/src/theme/theme.dart';

import '../blocs/auth_bloc.dart';
import 'home_page.dart';
import 'login_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc authBloc = AuthBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277D8)),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Image.asset('assets/icons/ic_car_red.png'),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text(
                    "Welcome Aboard",
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
              ),
              Text(
                  "Signup with iCab in simple steps",
                  style: TextStyle(fontSize: 16, color: Color(0xff606470)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 20),
                  child: StreamBuilder(
                    stream: authBloc.nameStream,
                    builder: (context, snapshot) =>TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        errorText:
                            snapshot.hasError ? snapshot.error.toString() : null,
                        labelText: "Name",
                        prefixIcon: Container(
                          width: 50,
                          child: Image.asset('assets/icons/ic_user.png'),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xffCED0D2),width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                      ),
                    ),
                  )

              ),
              StreamBuilder(
                  stream: authBloc.phoneStream,
                  builder: (context, snapshot) => TextField(
                    controller: _phoneController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Phone Number",
                      prefixIcon: Container(
                        width: 50,
                        child: Image.asset('assets/icons/ic_phone.png'),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                    ),
                  ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: StreamBuilder(
                  stream: authBloc.emailStream,
                  builder: (context, snapshot) => TextField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Email",
                      prefixIcon: Container(
                        width: 50,
                        child: Image.asset('assets/icons/ic_mail.png'),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xffCED0D2),width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: authBloc.passStream,
                  builder: (context, snapshot) => TextField(
                    controller: _passController,
                    obscureText: true,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
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
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onSignUpClicked,
                      child: Text(
                        "Đăng ký",
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
                      text: "Already a User? ",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const LoginPage())
                                );
                              },
                          text: "Login now",
                          style: TextStyle(
                            color: Color(0xff3277D8), fontSize: 16
                          )
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

  _onSignUpClicked() {
    var isValid = authBloc.isValid(_nameController.text, _emailController.text,
        _passController.text, _phoneController.text);
    if (isValid) {
      //create user
      // loading dialog
      LoadingDialog.showLoadingDialog(context, 'Loading...');
      authBloc.signUp(_emailController.text, _passController.text,
          _phoneController.text, _nameController.text, () {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Sign-In", msg);
       //show msg dialog
      });
    }
  }
}
