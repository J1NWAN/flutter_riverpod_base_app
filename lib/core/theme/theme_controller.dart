import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 테마 상태: seed 색상과 ThemeMode를 함께 관리한다.
class ThemeState {
  final Color seed;
  final ThemeMode mode;

  const ThemeState({
    required this.seed,
    required this.mode,
  });

  ThemeState copyWith({
    Color? seed,
    ThemeMode? mode,
  }) {
    return ThemeState(
      seed: seed ?? this.seed,
      mode: mode ?? this.mode,
    );
  }
}

/// ThemeState를 제어하는 컨트롤러.
class ThemeController extends StateNotifier<ThemeState> {
  ThemeController()
      : super(
          const ThemeState(
            seed: Colors.indigo,
            mode: ThemeMode.system,
          ),
        );

  void toggleThemeMode() {
    final next = switch (state.mode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.dark,
    };
    state = state.copyWith(mode: next);
  }

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setSeed(Color seed) {
    state = state.copyWith(seed: seed);
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>(
  (ref) => ThemeController(),
);
