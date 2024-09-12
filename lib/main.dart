import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart';
import 'package:task6_adv/blocs/category/bloc/category_bloc.dart';
import 'package:task6_adv/blocs/category/bloc/category_event.dart';
import 'package:task6_adv/blocs/coursesForCategory/bloc/course_for_category_bloc.dart';
import 'package:task6_adv/Cubits/auth/cubit/auth_cubit.dart';
import 'package:task6_adv/firebase_options.dart';
import 'package:task6_adv/pages/cart_page.dart';
import 'package:task6_adv/pages/categories_page.dart';
import 'package:task6_adv/pages/check_out_page.dart';
import 'package:task6_adv/pages/course_details_page.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/pages/on_boarding_page.dart';
import 'package:task6_adv/pages/reset_password_page.dart';
import 'package:task6_adv/pages/signup_page.dart';
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
   await dotenv.load(fileName: ".env");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(),
      ),
      BlocProvider(
        create: (_) => CartCubit()..fetchCartItems(),
      ),
      BlocProvider(
        create: (context) =>
            CategoryBloc(FirebaseFirestore.instance)..add(FetchCategories()),
      ),
      BlocProvider(create: (context) => CourseForCategoryBloc()),
    ],
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
          case CategoriesPage.id:
            return MaterialPageRoute(
                builder: (context) => const CategoriesPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(
                builder: (context) => const ResetPasswordPage());
          case CheckOutPage.id:
            return MaterialPageRoute(
                builder: (context) => const CheckOutPage(
                      course: null,
                    ));
          case CourseDetailsPage.id:
            return MaterialPageRoute(
                builder: (context) => const CourseDetailsPage(
                      courseId: '',
                    ));

          case CartPage.id:
            return MaterialPageRoute(
                builder: (context) => const CartPage(courseId: ''));
          
          default:
            return MaterialPageRoute(builder: (context) => const StartPage());
        }
      },
    
    );
  }
}
