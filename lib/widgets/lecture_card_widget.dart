import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class LectureCard extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String lectureUrl;
  final String courseId; // Add courseId to associate with the course
  final bool isSelected; // Add isSelected to handle color change
  final void Function() onTap;
  final bool isDownloaded;

  const LectureCard(
      {super.key,
      required this.title,
      required this.description,
      required this.duration,
      required this.onTap,
      required this.isSelected,
      required this.lectureUrl,
      required this.isDownloaded,
      required this.courseId}); // Include courseId

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  Future<void> _downloadLecture() async {
    // Check for storage permission
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      try {
        // Get the directory for storing the file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${widget.title}.mp4';

        // Download the file from Firebase Storage
        final ref = FirebaseStorage.instance.refFromURL(widget.lectureUrl);
        await ref.writeToFile(File(filePath)).whenComplete(() async {
          // Save lecture info to Firestore under 'downloads' collection
          await FirebaseFirestore.instance.collection('downloads').add({
            'title': widget.title,
            'description': widget.description,
            'duration': widget.duration,
            'lectureUrl': widget.lectureUrl,
            'filePath': filePath,
            'courseId': widget.courseId,
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Update the lecture info in the corresponding course's 'lectures' subcollection

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download complete: $filePath')),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading file: $e')),
        );
      }
    } else if (status.isDenied) {
      // Request permission
      if (await Permission.storage.request().isGranted) {
        _downloadLecture(); // Retry if permission is granted
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission not determined')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.isSelected ? ColorUtility.secondry : Colors.grey.shade200,
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
                  widget.isDownloaded
                      ? const Icon(
                          Icons.done_all,
                          color: ColorUtility.secondry,
                        )
                      : IconButton(
                          onPressed: _downloadLecture,
                          icon: const Icon(Icons.download_rounded),
                        )
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
