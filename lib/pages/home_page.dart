import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task6_adv/pages/course_page.dart';
import 'package:task6_adv/pages/profile_page.dart';
import 'package:task6_adv/pages/search_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/app_bar_title_widget.dart';
import 'package:task6_adv/widgets/homePage/home_content_widget.dart';
import 'package:task6_adv/widgets/my_app_bar.dart';
import 'package:task6_adv/widgets/my_label_text.dart';

class HomePage extends StatefulWidget {
  static const String id = 'HomePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  String? profileImageUrl; // To store profile image URL
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeContentWidget(), // You can place your main home content here
    const CoursePage(),
    const SearchPage(),
    const Center(child: Text('Chat Page')),
    const ProfilePage(), // The profile page for the user
  ];

  @override
  void initState() {
    super.initState();
    getUserNameAndProfileImage();
  }

  // Fetch user data from Firestore
  Future<void> getUserNameAndProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch user data from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = capitalize(userDoc['name'] ?? 'User');
          profileImageUrl = userDoc['profilePictureUrl'] ?? '';
        });
      }
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBarForPage(selectedIndex),
      body: SafeArea(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorUtility.scaffoldBackground,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: ColorUtility.secondry,
        unselectedItemColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 20,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.import_contacts,
              size: 20,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 20,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.comment,
              size: 20,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? CircleAvatar(
                    radius: 12, // Adjust the radius as needed
                    backgroundImage: NetworkImage(profileImageUrl!),
                    backgroundColor: Colors.transparent,
                  )
                : const Icon(
                    Icons.person,
                    size: 20,
                  ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget titleAppBarWidget() {
    return Row(
      children: [
        const MyLabelText(fontSize: 20, text: 'Welcome'),
        const SizedBox(width: 4),
        MyLabelText(
          fontSize: 20,
          text: username ?? '',
          color: ColorUtility.main,
        ),
      ],
    );
  }

  String capitalize(String? s) {
    if (s == null || s.isEmpty) {
      return '';
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  PreferredSizeWidget? getAppBarForPage(int index) {
    switch (index) {
      case 0:
        return MyAppBar(
          height: 40,
          title: titleAppBarWidget(),
        );
      case 1:
        return const MyAppBar(
          height: 40,
          title: AppBarTitleWidget(title: 'Courses'),
        );
      case 2:
        return const MyAppBar(
          height: 40,
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Search..',
              suffixIcon: Icon(Icons.search, color: Color(0xff505050)),
            ),
          ),
        );
      case 3:
        return const MyAppBar(
          height: 40,
          title: Text(
            'Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        );
      case 4:
        return const MyAppBar(
          height: 40,
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        );
      default:
        return const MyAppBar(
          height: 40,
          title: Text('Welcome'),
        );
    }
  }
}
