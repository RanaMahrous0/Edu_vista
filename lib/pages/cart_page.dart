import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_state.dart';
import 'package:task6_adv/pages/check_out_page.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/widgets/app_bar_title_widget.dart';
import 'package:task6_adv/widgets/cartPage/my_course_card_widget.dart';

class CartPage extends StatefulWidget {
  static const String id = 'CartPage';
  final String courseId;
  const CartPage({required this.courseId, super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const AppBarTitleWidget(title: 'Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(
              child: Text("Your cart is empty"),
            );
          }

          return ListView.builder(
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final course = state.cartItems[index];

              return MyCourseCardWidget(
                isCheckOut: false,
                buttonOneTitle: 'Cancel',
                buttonTwoTitle: 'Buy Now',
                course: course,
                buttonOneOnPressed: () {
                  context.read<CartCubit>().removeFromCart(course.id ?? '');
                },
                buttonTwoOnPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckOutPage(
                                course: course,
                              )));
                },
              );
            },
          );
        },
      ),
    );
  }
}
