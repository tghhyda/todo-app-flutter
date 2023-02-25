import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_flutter/model/User.dart';
import 'package:todo_app_flutter/screens/LoginPage.dart';

import '../main.dart';
import 'home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tdBGColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Wellcome to ToDo App",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Sign up below",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 44.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 44.0,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "User Email",
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                height: 26,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    errorText: _errorText,
                    hintText: "User password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                height: 26,
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    errorText: _confirmErrorText,
                    hintText: "User confirm password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: tdBlue,
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: signUp,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              signInOption()
            ],
          ),
        ));
  }

  String? get _errorText {
    final passwordText = passwordController.text.trim();

    if (passwordText.length < 6) {
      return 'The length of password must be more than 5';
    }
    return null;
  }

  String? get _confirmErrorText {
    final passwordText = passwordController.text.trim();
    final confirmText = confirmPasswordController.text.trim();

    if (!isSame(passwordText, confirmText)) {
      return 'The password and confirm password is not match';
    }
    return null;
  }

  Future signUp() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),));
    try {
      if (_errorText == null && _confirmErrorText == null) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .then((value) => addUserDetails(
                emailController.text.trim(), passwordController.text.trim()))
            .then((value) => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MainPage())));
      }else
        setState(() {});
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  bool isSame(String password, String confirm) {
    if (password == confirm) return true;
    return false;
  }

  Future addUserDetails(String email, String password) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(email);

    final Users user = Users(email: email, password: password);
    final json = user.toJson();
    await docUser.set(json);
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have account?",
            style: TextStyle(color: Colors.blue)),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            " Login",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
