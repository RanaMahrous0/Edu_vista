import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/Cubits/auth/cubit/auth_cubit.dart';
import 'package:task6_adv/widgets/auth/auth_template_widget.dart';
import 'package:task6_adv/widgets/my_textField_widget.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onLogin: () async {
        await context.read<AuthCubit>().login(
            context: context,
            emailController: emailController,
            passwordController: passwordController);
            
      },
      body: Column(
        children: [
          MyTextFieldWidget(
            hintText: 'UserName@domain.com',
            labelText: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 20,
          ),
          MyTextFieldWidget(
            hintText: 'Enter Password',
            labelText: 'Password',
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
