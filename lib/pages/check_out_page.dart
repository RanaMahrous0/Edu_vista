import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/pages/cart_page.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/pages/payment_method_page.dart';
import 'package:task6_adv/widgets/app_bar_title_widget.dart';
import 'package:task6_adv/widgets/cartPage/my_course_card_widget.dart';

class CheckOutPage extends StatefulWidget {
  static const String id = 'CheckOurPage';
  final Course? course;
  const CheckOutPage({required this.course, super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  double calculateTotalPrice(List<Course> cartItems) {
    double total = 0.0;
    for (var course in cartItems) {
      total += course.price ?? 0.0;
    }
    return total;
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyCourseCardWidget(
                  buttonOneTitle: 'Remove',
                  buttonTwoTitle: 'Checkout',
                  course: widget.course!,
                  buttonOneOnPressed: () {
                    context
                        .read<CartCubit>()
                        .removeFromCart(widget.course!.id ?? '');
                    Navigator.pushReplacementNamed(context, CartPage.id);
                  },
                  buttonTwoOnPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethodPage(
                                totalPrice: widget.course!.price ?? 0,courseId: widget.course!.id?? '',)));
                  },
                  isCheckOut: true),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '\$${widget.course!.price}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
