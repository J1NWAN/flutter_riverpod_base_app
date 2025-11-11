import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/responsive/app_responsive.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_controller.dart';
import 'demo_screen.dart';

/// FlexColorScheme + Responsive Framework 샘플 앱.
class DemoApp extends ConsumerWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flex + Responsive Demo',
      theme: AppTheme.light(themeState.seed),
      darkTheme: AppTheme.dark(themeState.seed),
      themeMode: themeState.mode,
      builder: responsiveBuilder,
      home: const _Home(),
    );
  }
}

class _Home extends ConsumerWidget {
  const _Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(themeControllerProvider.notifier);
    final state = ref.watch(themeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flex + Responsive Base'),
        actions: [
          IconButton(
            tooltip: 'Seed 변경',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () {
              const List<Color> seeds = <Color>[
                Colors.indigo,
                Colors.teal,
                Colors.deepOrange,
                Colors.pink,
                Colors.blueGrey,
              ];
              final currentIndex = seeds.indexWhere(
                (color) => color.value == state.seed.value,
              );
              final nextIndex =
                  currentIndex == -1 ? 0 : (currentIndex + 1) % seeds.length;
              controller.setSeed(seeds[nextIndex]);
            },
          ),
          IconButton(
            tooltip: '테마 전환',
            icon: Icon(switch (state.mode) {
              ThemeMode.dark => Icons.dark_mode,
              _ => Icons.light_mode,
            }),
            onPressed: controller.toggleThemeMode,
          ),
        ],
      ),
      body: const DemoScreen(),
    );
  }
}
