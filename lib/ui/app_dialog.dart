/// Modal dialog utility built on top of [showGeneralDialog].
/// - 사용처: 공통 확인/취소 모달이나 커스텀 콘텐츠를 담은 다이얼로그가 필요할 때.
/// - 특징: Material 3 친화적인 스타일, 페이드+스케일 애니메이션, 다양한 액션 버튼 지원.
library;

import 'package:flutter/material.dart';

/// Reusable dialog utilities for the app.
class AppDialog {
  const AppDialog._();

  /// Confirm dialog with common OK/Cancel actions.
  ///
  /// Usage:
  /// ```dart
  /// final result = await AppDialog.confirm(context,
  ///   title: '삭제',
  ///   message: '정말 삭제하시겠습니까?',
  /// );
  /// if (result == true) { /* 확인 */ }
  /// ```
  ///
  /// Returns:
  /// - `true` when confirm button tapped
  /// - `false` when cancel button tapped
  /// - `null` when dialog dismissed by barrier/escape/back
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool barrierDismissible = true,
  }) {
    final confirmAction = AppDialogAction<bool?>(
      label: confirmText,
      isPrimary: true,
      onPressed: () => true,
    );
    final cancelAction = AppDialogAction<bool?>(
      label: cancelText,
      onPressed: () => false,
    );

    return show<bool?>(
      context,
      title: title,
      message: message,
      actions: [cancelAction, confirmAction],
      barrierDismissible: barrierDismissible,
    );
  }

  /// General purpose dialog that accepts custom content and actions.
  ///
  /// Usage:
  /// ```dart
  /// await AppDialog.show<String>(
  ///   context,
  ///   title: '옵션 선택',
  ///   content: const Text('어떤 행동을 하시겠습니까?'),
  ///   actions: [
  ///     AppDialogAction(label: 'A', onPressed: () => 'A'),
  ///     AppDialogAction(label: '취소', onPressed: () => null),
  ///   ],
  /// );
  /// ```
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? content,
    String? message,
    List<AppDialogAction<T>> actions = const [],
    bool barrierDismissible = true,
    EdgeInsetsGeometry? padding,
    double? width,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final tokens = _DialogTokens.of(context);

    return showGeneralDialog<T>(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: colorScheme.scrim.withOpacity(0.5),
      transitionDuration: tokens.transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth =
                    width ??
                    (constraints.maxWidth > 480
                        ? 480
                        : constraints.maxWidth * 0.92);
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Material(
                    color: Colors.transparent,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final curved = Curves.easeOutCubic.transform(
                          animation.value,
                        );
                        final opacity = animation.value.clamp(0.0, 1.0);
                        final scale = 0.95 + (0.05 * curved);
                        return Opacity(
                          opacity: opacity,
                          child: Transform.scale(scale: scale, child: child),
                        );
                      },
                      child: Card(
                        color: colorScheme.surface,
                        elevation: tokens.elevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(tokens.radius),
                        ),
                        child: Padding(
                          padding:
                              padding ??
                              const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
                              ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: textTheme.titleLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              if (message != null || content != null) ...[
                                SizedBox(height: tokens.spacingMedium),
                                if (message != null)
                                  Text(
                                    message,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (content != null) content,
                              ],
                              if (actions.isNotEmpty) ...[
                                SizedBox(height: tokens.spacingLarge),
                                _DialogActions<T>(
                                  actions: actions,
                                  tokens: tokens,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

/// Dialog action descriptor used by [AppDialog.show].
///
/// Usage:
/// ```dart
/// AppDialogAction(
///   label: '삭제',
///   isDestructive: true,
///   onPressed: () => true,
/// )
/// ```
class AppDialogAction<T> {
  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  /// Button label.
  final String label;

  /// Callback returning a result that will be popped when pressed.
  final T? Function() onPressed;

  /// Whether this action is primary (accented).
  final bool isPrimary;

  /// Whether this action represents a destructive choice.
  final bool isDestructive;
}

class _DialogTokens {
  const _DialogTokens({
    required this.radius,
    required this.elevation,
    required this.spacingMedium,
    required this.spacingLarge,
    required this.buttonHeight,
    required this.transitionDuration,
  });

  final double radius;
  final double elevation;
  final double spacingMedium;
  final double spacingLarge;
  final double buttonHeight;
  final Duration transitionDuration;

  static _DialogTokens of(BuildContext context) {
    final media = MediaQuery.of(context);
    final isCompact = media.size.width < 360;
    return _DialogTokens(
      radius: 16,
      elevation: 6,
      spacingMedium: isCompact ? 12 : 16,
      spacingLarge: isCompact ? 16 : 20,
      buttonHeight: 44,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

class _DialogActions<T> extends StatelessWidget {
  const _DialogActions({required this.actions, required this.tokens});

  final List<AppDialogAction<T>> actions;
  final _DialogTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSingleAction = actions.length == 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children:
          actions.map((action) {
            final isPrimary = action.isPrimary;
            final isDestructive = action.isDestructive;

            Color background;
            Color foreground;
            ButtonStyle style;

            if (isPrimary) {
              background = colorScheme.primary;
              foreground = colorScheme.onPrimary;
              style = FilledButton.styleFrom(
                minimumSize: Size(64, tokens.buttonHeight),
                foregroundColor: foreground,
                backgroundColor: background,
                textStyle: textTheme.labelLarge,
              );
            } else if (isDestructive) {
              background = colorScheme.errorContainer;
              foreground = colorScheme.onErrorContainer;
              style = FilledButton.styleFrom(
                minimumSize: Size(64, tokens.buttonHeight),
                foregroundColor: foreground,
                backgroundColor: background,
                textStyle: textTheme.labelLarge,
              );
            } else {
              background = Colors.transparent;
              foreground = colorScheme.primary;
              style = TextButton.styleFrom(
                minimumSize: Size(64, tokens.buttonHeight),
                foregroundColor: foreground,
                textStyle: textTheme.labelLarge,
              );
            }

            final button =
                isPrimary || isDestructive
                    ? FilledButton(
                      onPressed:
                          () => Navigator.of(context).pop(action.onPressed()),
                      style: style,
                      child: Text(action.label),
                    )
                    : TextButton(
                      onPressed:
                          () => Navigator.of(context).pop(action.onPressed()),
                      style: style,
                      child: Text(action.label),
                    );

            final spacing = SizedBox(width: tokens.spacingMedium);
            return isSingleAction
                ? button
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [button, if (action != actions.last) spacing],
                );
          }).toList(),
    );
  }
}
