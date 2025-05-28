import 'package:flutter/material.dart';

import '../../../configs/routes/routes_name.dart';

class SignupRedirectText extends StatelessWidget {
  const SignupRedirectText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            // TODO: Navigate to sign-up screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.login,
              (route) => false,
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
