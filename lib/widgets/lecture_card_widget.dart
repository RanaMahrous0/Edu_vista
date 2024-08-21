import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class LectureCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final bool isFirst;

  const LectureCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: isFirst ? ColorUtility.secondry : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration $duration min',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Icon(Icons.play_circle_outline),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
