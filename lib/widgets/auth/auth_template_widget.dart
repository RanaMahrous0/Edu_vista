import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/pages/reset_password_page.dart';
import 'package:task6_adv/pages/signup_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/myTextButton.dart';
import 'package:task6_adv/widgets/my_elevated_button.dart';

class AuthTemplateWidget extends StatefulWidget {
  final Future<void> Function()? onLogin;
  final Future<void> Function()? onSignUp;
  final Widget body;
  final formKey = GlobalKey<FormState>();

  AuthTemplateWidget(
      {this.onLogin, this.onSignUp, required this.body, super.key}) {
    assert(onLogin != null || onSignUp != null,
        'onLogin or onSignUp should not be null');
  }

  @override
  State<AuthTemplateWidget> createState() => _AuthTemplateWidgetState();
}

class _AuthTemplateWidgetState extends State<AuthTemplateWidget> {
  EdgeInsetsGeometry get padding =>
      const EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  bool get isLogin => widget.onLogin != null;
  String get title => isLogin ? 'Login' : 'Sign Up';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: padding
            .subtract(const EdgeInsets.symmetric(vertical: 10, horizontal: 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                  thickness: 0.7,
                  color: ColorUtility.grayLight,
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Or sign with',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 0.7,
                  color: ColorUtility.grayLight,
                ))
              ],
            ),
            MyElevatedButton(
                onPressed: () {},
                width: 30,
                horizontal: 0,
                child: const FaIcon(FontAwesomeIcons.google)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    isLogin
                        ? 'Don\'t have an account?'
                        : 'Already have an account',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  MyTextButton(
                    onTap: () {
                      Navigator.pushNamed(
                          context, isLogin ? SignUpPage.id : LoginPage.id);
                    },
                    label: isLogin ? 'Sign Up' : 'Login',
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
          ),
          Expanded(
              child: Padding(
            padding: padding,
            child: SingleChildScrollView(
              child: Form(
                  key: widget.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.body,
                      isLogin
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                MyTextButton(
                                    label: 'Forget Password',
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, ResetPasswordPage.id);
                                    },),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Row(
                        children: [
                          Expanded(
                              child: MyElevatedButton(
                            onPressed: () async {
                              if (isLogin) {
                                setState(() {
                                  isLoading = true;
                                });
                                await widget.onLogin?.call();
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                await widget.onSignUp?.call();
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            horizontal: 0,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                          ),)
                        ],
                      )
                    ],
                  )),
            ),
          ))
        ],
      ),
    );
  }
}
