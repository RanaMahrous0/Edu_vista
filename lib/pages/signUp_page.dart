import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/cubit/auth_cubit.dart';
import 'package:task6_adv/widgets/auth/auth_template_widget.dart';
import 'package:task6_adv/widgets/my_textField_widget.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPage';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
        onSignUp: () async {
        
            await context.read<AuthCubit>().signUp(
                context: context,
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController);
          
        },
        body: Column(
          children: [
            MyTextFieldWidget(
              controller: nameController,
              hintText: 'Enter User Name ',
              labelText: 'Username',
              keyboardType: TextInputType.emailAddress,
              validator: validateUsername,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFieldWidget(
              controller: emailController,
              hintText: 'UserName@domain.com',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFieldWidget(
              controller: passwordController,
              hintText: 'Enter Password',
              labelText: 'Password',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: validatePassword,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFieldWidget(
              controller: confirmPasswordController,
              hintText: 'Re-enter your password',
              labelText: 'Confirm Password',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: validateConfirmPassword,
            ),
          ],
        ));
  }
}
