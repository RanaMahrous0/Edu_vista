import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_state.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_cubit.dart';
import 'package:task6_adv/pages/course_details_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/myTextButton.dart';
import 'package:task6_adv/widgets/my_label_text.dart';
import 'package:task6_adv/widgets/my_star_icon.dart';

class ViewedCoursesWidget extends StatefulWidget {
  final bool seeAll;
  const ViewedCoursesWidget({required this.seeAll, super.key});

  @override
  State<ViewedCoursesWidget> createState() => _ViewedCoursesWidgetState();
}

class _ViewedCoursesWidgetState extends State<ViewedCoursesWidget> {
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = _fetchCoursesBasedOnViewedUsers();
    context.read<CartCubit>().fetchCartItems();
  }

  Future<List<Course>> _fetchCoursesBasedOnViewedUsers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final userId = user.uid;

      // Fetch courses where 'viewedUsers' contains the current user ID
      final viewedCoursesQuery = await FirebaseFirestore.instance
          .collection('courses')
          .where('viewedUsers', arrayContains: userId)
          .get();

      if (viewedCoursesQuery.docs.isEmpty) {
        return [];
      }

      // Extract category IDs from viewed courses
      final categoryIds = viewedCoursesQuery.docs
          .map((doc) => doc.data()['categoryId'] as String?)
          .whereType<String>()
          .toSet();

      if (categoryIds.isEmpty) {
        return [];
      }

      // Fetch courses based on extracted category IDs
      final coursesQuery = await FirebaseFirestore.instance
          .collection('courses')
          .where('categoryId', whereIn: categoryIds.toList())
          .orderBy('created_date', descending: true)
          .get();

      return coursesQuery.docs
          .map((doc) => Course.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (error) {
      print('Error fetching courses: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return FutureBuilder<List<Course>>(
          future: futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              print('Error fetching courses: ${snapshot.error}');
              return Center(
                child: Text('Error loading courses: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Courses Found'),
              );
            }

            var courses = snapshot.data!;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.7,
              ),
              shrinkWrap: true,
              itemCount: widget.seeAll ? courses.length : 2,
              itemBuilder: (context, index) {
                final course = courses[index];
                final isInCart =
                    cartState.cartItems.any((item) => item.id == course.id);

                return InkWell(
                  onTap: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        String userId = user.uid;

                        await FirebaseFirestore.instance
                            .collection('courses')
                            .doc(course.id)
                            .update({
                          'viewedUsers': FieldValue.arrayUnion([userId])
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CourseDetailsPage(courseId: course.id ?? ''),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in first.')),
                        );
                      }
                    } catch (error) {
                      print('Error updating viewedUsers or navigating: $error');
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            course.image ?? '',
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Text(
                              course.rating.toString(),
                              style: const TextStyle(
                                color: Color(0xff060302),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            ...buildRatingStars(course.rating ?? 0),
                          ],
                        ),
                        const SizedBox(height: 7),
                        MyLabelText(
                          fontSize: 17,
                          text: course.title ?? '',
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Color(0xff060302),
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              course.instructor?.name ?? '',
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
                                '\$${course.price}',
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
                                            .addToCart(course);
                                      },
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
