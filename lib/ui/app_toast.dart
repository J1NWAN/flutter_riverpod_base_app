import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Toast/banner overlay utility using [OverlayEntry].
/// - 역할: 간단한 상태 알림, 처리 완료 메시지 등을 화면 상단/하단에 잠시 보여줍니다.
/// - 사용 시점: 페이지 전환 없이 사용자에게 빠른 피드백을 주고 싶을 때.
/// - 예시:
///   ```dart
///   AppToast.show(
///     context,
///     message: '저장되었습니다.',
///     type: AppToastType.success,
///   );
///   ```
enum AppToastPosition { top, bottom }

enum AppToastType { info, success, warning, error }

class AppToast {
  AppToast._();

  static final Map<AppToastPosition, OverlayEntry> _activeEntries = {};
  static final Map<AppToastPosition, Timer> _activeTimers = {};

  /// Overlay 기반 토스트 표시.
  ///
  /// 사용 예시:
  /// ```dart
  /// await AppToast.show(
  ///   context,
  ///   message: '네트워크 오류가 발생했습니다.',
  ///   type: AppToastType.error,
  ///   position: AppToastPosition.bottom,
  /// );
  /// ```
  static Future<void> show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    AppToastPosition position = AppToastPosition.top,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
    Color? background,
    Color? foreground,
    EdgeInsetsGeometry? margin,
    double? maxWidth,
    void Function()? onTap,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final OverlayState? rootOverlay = navigator.overlay;
    final overlay = rootOverlay ?? Overlay.of(context, rootOverlay: true);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedColors = _ToastColors.resolve(
      colorScheme: colorScheme,
      type: type,
      backgroundOverride: background,
      foregroundOverride: foreground,
    );
    final iconData = icon ?? resolvedColors.icon;

    final overlayEntry = OverlayEntry(
      builder: (ctx) {
        final direction = Directionality.maybeOf(ctx) ?? TextDirection.ltr;
        SemanticsService.announce(message, direction);
        final safeMargin =
            margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

        return SafeArea(
          minimum:
              safeMargin is EdgeInsets
                  ? safeMargin
                  : safeMargin.resolve(direction),
          child: Align(
            alignment:
                position == AppToastPosition.top
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
            child: _ToastContainer(
              message: message,
              colors: resolvedColors,
              icon: iconData,
              position: position,
              maxWidth: maxWidth ?? 560,
              onTap: () {
                onTap?.call();
                _removeEntry(position);
              },
            ),
          ),
        );
      },
    );

    _replaceEntry(position, overlayEntry);
    overlay.insert(overlayEntry);

    _activeTimers[position]?.cancel();
    _activeTimers[position] = Timer(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      _activeTimers.remove(position);
      _activeEntries.remove(position);
    });
  }

  static void _replaceEntry(AppToastPosition position, OverlayEntry entry) {
    final existingEntry = _activeEntries[position];
    if (existingEntry != null && existingEntry.mounted) {
      existingEntry.remove();
    }
    _activeEntries[position] = entry;
  }

  static void _removeEntry(AppToastPosition position) {
    _activeTimers[position]?.cancel();
    _activeTimers.remove(position);

    final entry = _activeEntries.remove(position);
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }
}

class _ToastColors {
  const _ToastColors({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData? icon;

  static _ToastColors resolve({
    required ColorScheme colorScheme,
    required AppToastType type,
    Color? backgroundOverride,
    Color? foregroundOverride,
  }) {
    final IconData defaultIcon;
    Color background;
    Color foreground;

    switch (type) {
      case AppToastType.success:
        background = colorScheme.tertiaryContainer;
        foreground = colorScheme.onTertiaryContainer;
        defaultIcon = Icons.check_circle_outline;
        break;
      case AppToastType.warning:
        background = colorScheme.secondaryContainer;
        foreground = colorScheme.onSecondaryContainer;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case AppToastType.error:
        background = colorScheme.errorContainer;
        foreground = colorScheme.onErrorContainer;
        defaultIcon = Icons.error_outline;
        break;
      case AppToastType.info:
        background = colorScheme.primaryContainer;
        foreground = colorScheme.onPrimaryContainer;
        defaultIcon = Icons.info_outline;
        break;
    }

    return _ToastColors(
      background: backgroundOverride ?? background,
      foreground: foregroundOverride ?? foreground,
      icon: defaultIcon,
    );
  }
}

class _ToastContainer extends StatefulWidget {
  const _ToastContainer({
    required this.message,
    required this.colors,
    required this.icon,
    required this.position,
    required this.maxWidth,
    this.onTap,
  });

  final String message;
  final _ToastColors colors;
  final IconData? icon;
  final AppToastPosition position;
  final double maxWidth;
  final VoidCallback? onTap;

  @override
  State<_ToastContainer> createState() => _ToastContainerState();
}

class _ToastContainerState extends State<_ToastContainer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final offsetDirection =
        widget.position == AppToastPosition.top
            ? const Offset(0, -1)
            : const Offset(0, 1);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final opacity = value.clamp(0.0, 1.0);
        final slideOffset = Offset(
          offsetDirection.dx * (1 - opacity),
          offsetDirection.dy * 0.05,
        );
        return Opacity(
          opacity: opacity,
          child: Transform.translate(offset: slideOffset, child: child),
        );
      },
      child: Material(
        color: widget.colors.background,
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: widget.colors.foreground),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Text(
                      widget.message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: widget.colors.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
