import 'package:do_host/configs/color/color.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Verify OTP \nto \nDO Host Network!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors
                .buttonColor, // Ensure this is the correct color reference
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Connect with professionals in the Hospitality industry.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: AppColors.blackColor),
        ),
      ],
    );
  }
}
