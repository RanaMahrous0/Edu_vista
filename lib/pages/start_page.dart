import 'package:flutter/material.dart';
import 'package:task6_adv/utility/image_utility.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageUtility.logo),
      ),
    );
  }
}
