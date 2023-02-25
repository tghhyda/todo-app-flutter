import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/constants/colors.dart';
import 'package:basic_utils/basic_utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Reset password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receive an email to \nreset your password',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: "Email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null ? 'Enter a valid email' : null,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  resetPassword();
                },
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                icon: Icon(Icons.email_outlined),
                label: Text(
                  'Reset password',
                  style: TextStyle(fontSize: 24),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),));
    try{

      final snackBar = SnackBar(
        content: const Text('Reset password email sent',
        style: TextStyle(color: Colors.red),),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    } on FirebaseAuthException catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(e.message as SnackBar);
      Navigator.of(context).pop();
    }


  }
}
