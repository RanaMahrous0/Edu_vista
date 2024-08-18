import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/cubit/auth_cubit.dart';
import 'package:task6_adv/firebase_options.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/pages/on_boarding_page.dart';
import 'package:task6_adv/pages/reset_password_page.dart';
import 'package:task6_adv/pages/signUp_page.dart';
import 'package:task6_adv/pages/start_page.dart';
import 'package:task6_adv/services/pref_service.dart';
import 'package:task6_adv/utility/color_utility.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PerferenceService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize firebase: $e');
  }
  runApp(BlocProvider(
    create: (context) => AuthCubit(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'PlusJakartaSans',
          colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
          scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
          useMaterial3: true),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';

        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(
                builder: (context) => const OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => const HomePage());
                    case ResetPasswordPage.id:
            return MaterialPageRoute(builder: (context) => const ResetPasswordPage());
          default:
            return MaterialPageRoute(builder: (context) => const StartPage());
        }
      },
    );
  }
}
