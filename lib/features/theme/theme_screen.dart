import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base_app/core/theme/theme_controller.dart';
import 'package:flutter_riverpod_base_app/core/token/app_tokens.dart';

class ThemeScreen extends ConsumerStatefulWidget {
  const ThemeScreen({super.key});

  @override
  ConsumerState<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends ConsumerState<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeControllerProvider);
    final themeMode = themeState.mode;
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Text(
                  '화면 테마',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Text('밝은 모드', style: theme.textTheme.bodyMedium),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeControllerProvider.notifier).setMode(value);
                }
              },
            ),
          ),
          ListTile(
            leading: Text('어두운 모드', style: theme.textTheme.bodyMedium),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeControllerProvider.notifier).setMode(value);
                }
              },
            ),
          ),
          ListTile(
            leading: Text('시스템 설정과 같이', style: theme.textTheme.bodyMedium),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeControllerProvider.notifier).setMode(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
