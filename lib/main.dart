import 'package:flutter/material.dart';
import 'package:task6_adv/pages/on_boarding_page.dart';
import 'package:task6_adv/pages/start_page.dart';
import 'package:task6_adv/utility/color_utility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'PlusJakartaSans',
          colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
          scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
          useMaterial3: true),
      // home: const StartPage(),
      home: const OnBoardingPage(),
    );
  }
}
