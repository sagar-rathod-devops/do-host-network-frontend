import 'package:do_host/view/favourites/favourites_screen.dart';
import 'package:do_host/view/home/home_screen.dart';
import 'package:do_host/view/my_home/widget/logout_button_widget.dart';
import 'package:do_host/view/profile/profile_screen.dart';
// import 'package:do_host/view/profile/profile_screen.dart';
import 'package:do_host/view/search/search_screen.dart';
import 'package:do_host/view/job/job_screen.dart';
import 'package:flutter/material.dart';

import '../../configs/color/color.dart';
import '../../services/session_manager/session_controller.dart';
import '../post/choose_post_type_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? id = await SessionController().getUserId();
    setState(() {
      userId = id;
    });
  }

  List<Widget> get _pages => [
    HomeScreen(userId: userId),
    JobsScreen(userId: userId),
    SearchScreen(userId: userId),
    FavouritesScreen(userId: userId),
    ProfileScreen(userId: userId),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        title: const Text(
          'Do Host Network',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipOval(
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          // Add a button to navigate to the PostScreen
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.whiteColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoosePostTypeScreen(userId: userId),
                ),
              );
            },
          ),
          const SizedBox(width: 25),
          const LogoutButtonWidget(),
          const SizedBox(width: 25),
        ],
        centerTitle: false,
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.deepOrangeAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFFF5F5F5),
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 20),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.work : Icons.work_outline),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.search_rounded : Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4
                  ? Icons.account_circle
                  : Icons.account_circle_outlined,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Widget _buildNavItem(IconData icon, String label, int index) {
  //   return GestureDetector(
  //     onTap: () => _onItemTapped(index),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(
  //           icon,
  //           size: 22, // Reduced icon size
  //           color: _selectedIndex == index ? Colors.white : const Color(0xFFF5F5F5),
  //         ),
  //         if (_selectedIndex == index)
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               fontSize: 10, // Smaller font
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
}
