import 'package:do_host/configs/color/color.dart';
import 'package:flutter/material.dart';
import '../../services/splash/splash_services.dart'; // Importing the SplashServices class from the services/splash/splash_services.dart file

/// A widget representing the splash screen of the application.
class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

/// The state of the [SplashView] widget.
class _SplashViewState extends State<SplashView> {
  final SplashServices splashServices =
      SplashServices(); // Instance of SplashServices for handling splash screen logic

  @override
  void initState() {
    super.initState();
    // Calls the [checkAuthentication] method from [SplashServices] to handle authentication logic
    splashServices.checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 50.0,
                end: 150.0,
              ), // Animate from 50 to 150 for the icon
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, size, child) {
                return ClipOval(
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 24.0,
                end: 36.0,
              ), // Animate text font size from 24 to 36
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, fontSize, child) {
                return Text(
                  'Do Host Network',
                  style: TextStyle(
                    fontSize: fontSize, // Animated font size
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
