import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class LectureCard extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String lectureUrl;

  const LectureCard(
      {super.key,
      required this.title,
      required this.description,
      required this.duration,
      required this.lectureUrl});

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  bool isTapped = false;
  void handleOnTapped() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleOnTapped();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isTapped ? ColorUtility.secondry : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded))
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duration ${widget.duration} min',
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
