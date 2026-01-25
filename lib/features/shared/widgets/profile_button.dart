import 'package:diato_ai/features/auth/login/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../auth/core/cubit/auth_cubit.dart';
import '../actionable/app_button.dart';
import 'spacings.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
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
                Text(state.user.name.split(' ').first),
              ],
            ),
          );
        } else {
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
      },
    );
  }
}
