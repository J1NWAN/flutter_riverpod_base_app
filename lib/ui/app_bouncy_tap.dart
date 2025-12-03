import 'package:flutter/material.dart';

/// 어디에나 쓸 수 있는 공통 bounce 터치 위젯
class AppBouncyTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  /// 눌렸을 때 scale 값 (default: 0.94)
  final double pressedScale;

  /// halo(배경 + 그림자) 보여줄지 여부
  final bool showHalo;

  const AppBouncyTap({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.95,
    this.showHalo = true,
  });

  @override
  State<AppBouncyTap> createState() => _AppBouncyTapState();
}

class _AppBouncyTapState extends State<AppBouncyTap> {
  double _scale = 1.0;
  bool _isPressed = false;

  static const Duration _duration = Duration(milliseconds: 130);

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
      _scale = widget.pressedScale;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
      _scale = 1.0;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
      _scale = 1.0;
    });

    if (widget.onTap != null) {
      Future.microtask(widget.onTap!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = AnimatedScale(
      scale: _scale,
      duration: _duration,
      curve: Curves.easeOutBack,
      child: widget.child,
    );

    // halo 효과를 안 쓰고 싶으면 바로 반환
    if (!widget.showHalo) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _onTapDown,
        onTapCancel: _onTapCancel,
        onTapUp: _onTapUp,
        child: content,
      );
    }

    // halo + bounce
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTapUp: _onTapUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        // margin은 밖에서 주는 게 좋으면 빼도 됨
        // 여기선 공통적으로 살짝만 줌
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color:
              _isPressed
                  ? colorScheme.primary.withOpacity(0.06)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: content,
      ),
    );
  }
}
