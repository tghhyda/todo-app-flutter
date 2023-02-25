import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/colors.dart';
import 'package:todo_app_flutter/screens/ForgotPasswordPage.dart';
import 'package:todo_app_flutter/screens/SignUpPage.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            "Login below",
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
            decoration: InputDecoration(
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
                hintText: "User password",
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage()));
                },
              ),
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: tdBlue,
              elevation: 0.0,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              onPressed: signIn,
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          signUpOption()
        ],
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      errorMessage = '';
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message!;
      setState(() {});
    }
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(color: Colors.blue)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
