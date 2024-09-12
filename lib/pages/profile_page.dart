import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task6_adv/pages/login_page.dart';
import 'package:task6_adv/utility/color_utility.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;
  String? downloadURL;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      currentUser = auth.currentUser;
    });

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          downloadURL = userDoc['profilePictureUrl'];
        });
      }
    }
  }

  Future<void> logout() async {
    await auth.signOut();

    // Navigate to login page after logout
    Navigator.pushReplacementNamed(context, LoginPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfilePicture(downloadURL ?? ''),
          const SizedBox(height: 10),
          Text(
            currentUser?.displayName ?? 'No Name',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            currentUser?.email ?? 'No Email',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _buildProfileOption('Edit'),
          _buildProfileOption('Setting'),
          _buildProfileOption('Achievements'),
          _buildProfileOption('About Us'),
          const SizedBox(height: 20),
          TextButton(
            onPressed: logout,
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(String url) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imageFile != null
              ? FileImage(imageFile!)
              : downloadURL != null
                  ? NetworkImage(url)
                  : const AssetImage('assets/images/default.jpg')
                      as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.keyboard_double_arrow_right),
        tileColor: ColorUtility.whiteGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {},
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      if (auth.currentUser == null) return;

      // Create a unique file name for the image
      String fileName = 'profile_${auth.currentUser!.uid}.png';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      // Upload the image file
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        this.downloadURL = downloadURL;
      });

      // Save the download URL to the user's Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'profilePictureUrl': downloadURL,
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
