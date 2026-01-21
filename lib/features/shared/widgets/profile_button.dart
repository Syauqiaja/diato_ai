import 'package:diato_ai/features/auth/login/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../actionable/app_button.dart';
import 'spacings.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      backgroundColor: AppButtonColorType.white,
      foregroundColor: AppButtonColorType.primary,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      onPressed: () {
        context.pushNamed(LoginScreen.routeName);
      },
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.userGraduate, size: 20),
          hSpace(8),
          Text("Login"),
        ],
      ),
    );
  }
}
