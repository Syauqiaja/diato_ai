import 'package:diato_ai/core/theme/theme.dart';
import 'package:diato_ai/features/setting/presentation/app_info_screen.dart';
import 'package:diato_ai/features/setting/presentation/developer_info_screen.dart';
import 'package:diato_ai/features/setting/presentation/usage_guide_screen.dart';
import 'package:diato_ai/features/shared/widgets/spacings.dart';
import 'package:diato_ai/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';
  static const String routePath = '/settings';
  const SettingsScreen({super.key});

  static void push(BuildContext context) {
    context.pushNamed(routeName);
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryCanvasColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: context.colorScheme.primary),
                  ),
                  Text('Tentang', style: context.textTheme.displayLarge?.copyWith(color: context.colorScheme.primary)),
                ],
              ),
              vSpace(16),
              Expanded(
                child: ListView(
                  children: [
                    _SettingItem(title: 'Tentang Diatom-AI', icon: Icons.info_outline, onTap: () => AppInfoScreen.push(context)),
                    vSpace(12),
                    _SettingItem(title: 'Petunjuk Penggunaan', icon: Icons.help_outline, onTap: () => UsageGuideScreen.push(context)),
                    vSpace(12),
                    _SettingItem(title: 'Informasi Pengembang', icon: Icons.code, onTap: () => DeveloperInfoScreen.push(context)),
                  ],
                ),
              ),
              vSpace(kBotbarHeight),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingItem({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(color: context.colorScheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 32, color: context.colorScheme.primary),
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.primary),
        onTap: onTap,
      ),
    );
  }
}
