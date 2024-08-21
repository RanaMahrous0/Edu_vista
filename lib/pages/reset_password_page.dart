import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/widgets/my_elevated_button.dart';
import 'package:task6_adv/widgets/my_textField_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String id = 'resetPassword';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  String? message;
  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      setState(() {
        message = 'Password reset email sent! Check your inbox.';
      });
      if(mounted){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message ?? ''),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacementNamed(context, LoginPage.id);
      }
     
    } catch (e) {
      setState(() {
        message = 'Failed to send password reset email: $e';
      });
      if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message ?? ''),
        backgroundColor: Colors.red,
      ));
      }
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyTextFieldWidget(
                controller: emailController,
                hintText: 'Demo@gmail.com',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                child: const Text(
                  'Send Password Reset Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
