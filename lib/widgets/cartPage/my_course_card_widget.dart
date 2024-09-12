import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_state.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/cartPage/my_cart_elevated_button.dart';
import 'package:task6_adv/widgets/my_star_icon.dart';

class MyCourseCardWidget extends StatelessWidget {
  final Course course;
  final String buttonOneTitle;
  final String buttonTwoTitle;
  final void Function() buttonOneOnPressed;
  final void Function() buttonTwoOnPressed;
  final bool isCheckOut;

  const MyCourseCardWidget({
    required this.buttonOneTitle,
    required this.buttonTwoTitle,
    required this.course,
    required this.buttonOneOnPressed,
    required this.buttonTwoOnPressed,
    required this.isCheckOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        bool isInCart = cartState.cartItems.any((item) => item.id == course.id);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            color: ColorUtility.scaffoldBackground,
            surfaceTintColor: ColorUtility.scaffoldBackground,
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        course.image ?? '',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Color(0xff060302),
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                course.instructor!.name ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                course.rating.toString(),
                                style: const TextStyle(
                                    color: Color(0xff060302),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              ...buildRatingStars(course.rating ?? 0),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Price
                          Text(
                            '\$${course.price}',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isCheckOut
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: Icon(
                              course.isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                            onPressed: () {
                              context.read<CartCubit>().toggleExpand(course);
                            },
                          ),
                  ],
                ),
                if (course.isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: MyCartElevatedButton(
                            title:
                                isInCart ? 'Remove from Cart' : 'Add to Cart',
                            isBuy: false,
                            onPressed: isInCart
                                ? () {
                                    context
                                        .read<CartCubit>()
                                        .removeFromCart(course.id!);
                                  }
                                : () {
                                    context.read<CartCubit>().addToCart(course);
                                  },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: MyCartElevatedButton(
                            title: buttonTwoTitle,
                            isBuy: true,
                            onPressed: buttonTwoOnPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    int halfStars = (rating - fullStars >= 0.5) ? 1 : 0;
    int emptyStars = 5 - fullStars - halfStars;

    for (int i = 0; i < fullStars; i++) {
      stars.add(const MyStarIcon(iconData: Icons.star));
    }

    if (halfStars == 1) {
      stars.add(const MyStarIcon(iconData: Icons.star_half));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(const MyStarIcon(iconData: Icons.star_border));
    }

    return stars;
  }
}
