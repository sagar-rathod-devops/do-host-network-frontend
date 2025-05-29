import 'package:flutter/material.dart';
import 'package:do_host/view/favourites/favourites_screen.dart';
import 'package:do_host/view/home/home_screen.dart';
import 'package:do_host/view/job/job_screen.dart';
import 'package:do_host/view/my_home/widget/logout_button_widget.dart';
import 'package:do_host/view/post/choose_post_type_screen.dart';
import 'package:do_host/view/profile/profile_screen.dart';
import 'package:do_host/view/search/search_screen.dart';

import '../../configs/color/color.dart';
import '../../services/session_manager/session_controller.dart';

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
    final id = await SessionController().getUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => userId = id);
      }
    });
  }

  List<Widget> get _pages => userId == null
      ? []
      : [
          HomeScreen(userId: userId),
          JobsScreen(userId: userId),
          SearchScreen(userId: userId),
          FavouritesScreen(),
          ProfileScreen(userId: userId),
        ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  BottomNavigationBar get _bottomNavigationBar => BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    backgroundColor: AppColors.buttonColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: const Color(0xFFF5F5F5),
    selectedFontSize: 12,
    unselectedFontSize: 10,
    selectedIconTheme: const IconThemeData(size: 28),
    unselectedIconTheme: const IconThemeData(size: 20),
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'Jobs',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        activeIcon: Icon(Icons.search_rounded),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border_outlined),
        activeIcon: Icon(Icons.favorite),
        label: 'Favourites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined),
        activeIcon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
    ],
  );

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
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.whiteColor),
            onPressed: () {
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChoosePostTypeScreen(userId: userId),
                  ),
                );
              }
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
          : LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth >= 800;

                return isDesktop
                    ? Column(
                        children: [
                          _bottomNavigationBar, // Show on top
                          Expanded(
                            child: PageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: _pages,
                            ),
                          ),
                        ],
                      )
                    : PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _pages,
                      );
              },
            ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 800;
          return isDesktop ? const SizedBox.shrink() : _bottomNavigationBar;
        },
      ),
    );
  }
}
