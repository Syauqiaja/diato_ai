import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      onPressed: () {},
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
