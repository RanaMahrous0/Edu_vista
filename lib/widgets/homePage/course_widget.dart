import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for user information
import 'package:task6_adv/Cubits/cart/cubit/cart_state.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart'; // Import the CartCubit
import 'package:task6_adv/pages/course_details_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/myTextButton.dart';
import 'package:task6_adv/widgets/my_label_text.dart';
import 'package:task6_adv/widgets/my_star_icon.dart';

class CoursesWidget extends StatefulWidget {
  final String rankValue;
  const CoursesWidget({required this.rankValue, super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    super.initState();

    // Fetch all the courses based on rank
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .orderBy('created_date', descending: true)
        .get();

    context.read<CartCubit>().fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return FutureBuilder(
          future: futureCall,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              // Log the error and display a user-friendly message
              print('Error fetching courses: ${snapshot.error}');
              return Center(
                child: Text('Error in Loading Courses: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
              return const Center(
                child: Text('No Courses Found'),
              );
            }

            var courses = snapshot.data?.docs
                    .map(
                      (e) => Course.fromJson({'id': e.id, ...e.data()}),
                    )
                    .toList() ??
                [];

            return GridView.count(
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              children: List.generate(courses.length, (index) {
                bool isInCart = cartState.cartItems
                    .any((item) => item.id == courses[index].id);

                return InkWell(
                  onTap: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        String userId = user.uid;

                        // Update the course document's 'watchedUsers' array
                        await FirebaseFirestore.instance
                            .collection('courses')
                            .doc(courses[index].id)
                            .update({
                          'viewedUsers': FieldValue.arrayUnion([userId])
                        });

                        // Navigate to course details page after adding the user ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailsPage(
                                courseId: courses[index].id ?? ''),
                          ),
                        );
                      } else {
                        // Handle case where the user is not logged in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in first.')),
                        );
                      }
                    } catch (error) {
                      // Handle any Firestore update errors or navigation errors
                      print(
                          'Error updating watchedUsers or navigating: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to load course details.')),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorUtility.scaffoldBackground,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            courses[index].image ?? '',
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              courses[index].rating.toString(),
                              style: const TextStyle(
                                color: Color(0xff060302),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ...buildRatingStars(courses[index].rating ?? 0),
                          ],
                        ),
                        const SizedBox(height: 7),
                        MyLabelText(
                            fontSize: 17, text: courses[index].title ?? ''),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Color(0xff060302),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              courses[index].instructor?.name ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${courses[index].price}',
                                style: const TextStyle(
                                  color: ColorUtility.main,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                              isInCart
                                  ? const Text(
                                      'Already in Cart',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : MyTextButton(
                                      label: 'Add To Cart',
                                      onTap: () {
                                        context
                                            .read<CartCubit>()
                                            .addToCart(courses[index]);
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
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
