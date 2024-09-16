import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task6_adv/utility/color_utility.dart';

class LectureCard extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String lectureUrl;
  final String courseId;
  final bool isSelected;
  final void Function() onTap;
  final bool isDownloaded;

  const LectureCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.onTap,
    required this.isSelected,
    required this.lectureUrl,
    required this.isDownloaded,
    required this.courseId,
  });

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  Future<void> _downloadLecture() async {
    try {
      // Check if lecture already exists in Firestore
      final existingDocs = await FirebaseFirestore.instance
          .collection('downloads')
          .where('title', isEqualTo: widget.title)
          .where('courseId', isEqualTo: widget.courseId)
          .get();

      if (existingDocs.docs.isNotEmpty) {
        // Document already exists, so do not proceed with download and upload
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lecture already downloaded.')),
        );
        return;
      }

      // Download the file from the provided URL
      final response = await http.get(Uri.parse(widget.lectureUrl));

      if (response.statusCode == 200) {
        // Get the file data
        final Uint8List fileData = response.bodyBytes;

        // Define the Firebase Storage path
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('lectures/${widget.title}.mp4');

        // Upload the file to Firebase Storage
        await storageRef.putData(fileData);

        // Save lecture info to Firestore under 'downloads' collection
        await FirebaseFirestore.instance.collection('downloads').add({
          'title': widget.title,
          'description': widget.description,
          'duration': widget.duration,
          'lectureUrl': widget.lectureUrl,
          'courseId': widget.courseId,
          'timestamp': FieldValue.serverTimestamp(),
          'firebaseStoragePath': storageRef.fullPath,
          'userId': FirebaseAuth.instance.currentUser
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload complete: ${storageRef.fullPath}')),
        );
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
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
                        ),
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
