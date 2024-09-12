import 'package:flutter/material.dart';
import 'package:task6_adv/models/course.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/my_label_text.dart';
import 'package:task6_adv/widgets/my_star_icon.dart';

class CourseItemWidget extends StatelessWidget {
  final Course course;
  const CourseItemWidget({required this.course, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              course.image ?? '',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
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
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                width: 4,
              ),
              ...buildRatingStars(course.rating ?? 0)
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          MyLabelText(
            text: course.title ?? '',
            fontSize: 17,
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
                course.instructor!.name ?? '',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            '\$${course.price}',
            style: const TextStyle(
                color: ColorUtility.main,
                fontWeight: FontWeight.w800,
                fontSize: 18),
          )
        ],
      ),
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
