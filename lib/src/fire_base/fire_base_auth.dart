// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class FireAuth {
//
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//
//   void signUp(String email, String pass, String name, String phone,
//       Function onSuccess, Function(String) onRegisterError) {
//     // _createUser(email, name, phone, onSuccess, onRegisterError);
//     _firebaseAuth
//         .createUserWithEmailAndPassword(email: email, password: pass)
//         .then((user) {
//       _createUser(user.uid, name, phone, onSuccess, onRegisterError);
//       print(user);
//       //   .createUserWithEmailAndPassword(email: email, password: pass)
//       //   .then((userCredential) {
//       // String? uid = userCredential.user?.uid; // Lấy uid từ UserCredential
//       // _createUser(uid!, name, phone, onSuccess, onRegisterError);
//       // print(userCredential.user);
//     }).catchError((err) {
//       _onSignUpErr(err.code, onRegisterError);
//     });
//   }
//
//   _createUser(String userId, String name, String phone, Function onSuccess,
//       Function(String) onRegisterError) {
//     var user = {"name" : name, "phone" : phone};
//     var ref = FirebaseDatabase.instance.ref().child("users");
//     ref.child(userId).set(user).then((user) {
//       //success
//       onSuccess();
//     }).catchError((err) {
//       onRegisterError("Signup fail, please try again");
//     });
//   }
//
//   void _onSignUpErr(String code, Function(String) onRegisterError) {
//     print("Error code: $code");
//     switch (code) {
//       case "ERROR_INVALID_EMAIL":
//       case "ERROR_INVALID_CREDENTIAL":
//         onRegisterError("Invalid email");
//         break;
//       case "ERROR_EMAIL_ALREADY_IN_USE":
//         onRegisterError("Email has existed");
//         break;
//       case "ERROR_WEAK_PASSWORD":
//         onRegisterError("The password is not strong enough");
//         break;
//       default:
//         onRegisterError("Signup fail, please try again");
//         break;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FireAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((userCredential) {
      String userId = userCredential.user!.uid;
      _createUser(userId, email, name, phone, onSuccess, onRegisterError);
      print(userCredential.user);
    }).catchError((err) {
      _onSignUpErr(err.code, onRegisterError);
    });
  }

  _createUser(String userId,String email, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {"email" : email, "name" : name, "phone" : phone};
    var ref = FirebaseDatabase.instance.ref().child("users");
    ref.child(userId).set(user).then((user) {
      //success
      onSuccess();
    }).catchError((err) {
      onRegisterError("Signup fail, please try again");
    });
  }

  void signIn(String email, String pass, Function onSuccess, Function(String) onSignInError) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: pass).then((userCredential) {
      print("on sign in success");
      onSuccess();
    }).catchError((err){
      onSignInError("Sign-In fail, please try again");
    });
  }

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Invalid email");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email has existed");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("The password is not strong enough");
        break;
      default:
        onRegisterError("Signup fail, please try again");
        break;
    }
  }

}
