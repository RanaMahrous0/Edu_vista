import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/pages/on_boarding_page.dart';
import 'package:task6_adv/services/pref_service.dart';
import 'package:task6_adv/utility/image_utility.dart';

class StartPage extends StatefulWidget {
  static const String id = 'StartPage';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageUtility.logo),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      if (PerferenceService.isOnBoardingSeen) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacementNamed(context, HomePage.id);
        } else {
          Navigator.pushReplacementNamed(context, LoginPage.id);
        }
      } else {
        Navigator.pushReplacementNamed(context, OnBoardingPage.id);
      }
    }
  }
}
