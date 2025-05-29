import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/view/favourites/favourites_screen.dart';
import 'package:do_host/view/home/home_screen.dart';
import 'package:do_host/view/job/job_screen.dart';
import 'package:do_host/view/profile/profile_screen.dart';
import 'package:do_host/view/reset_password/reset_password_screen.dart';
import 'package:do_host/view/search/search_screen.dart';
import 'package:do_host/view/signup/signup_screen.dart';
import 'package:do_host/view/verify_otp/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import '../../view/forgot_password/forgot_password_screen.dart';
import '../../view/my_home/my_home_screen.dart';
import '../../view/views.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashView(),
        );

      case RoutesName.home_movies:
        return MaterialPageRoute(
          builder: (BuildContext context) => const MoviesScreen(),
        );

      case RoutesName.register:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignupScreen(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );

      case RoutesName.verifyOTP:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => VerifyOtpScreen(email: email),
        );

      case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPasswordScreen(),
        );

      case RoutesName.resetPassword:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => ResetPasswordScreen(email: email),
        );

      case RoutesName.myHome:
        return MaterialPageRoute(
          builder: (BuildContext context) => const MyHomeScreen(),
        );

      case RoutesName.profile:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => ProfileScreen(userId: userId),
        );

      case RoutesName.home:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(userId: userId),
        );

      case RoutesName.jobs:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => JobsScreen(userId: userId),
        );

      case RoutesName.search:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => SearchScreen(userId: userId),
        );

      case RoutesName.favourites:
        // final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => FavouritesScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
