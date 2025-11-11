import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 화면 크기를 Phone/Tablet/Desktop 범주로 구분한다.
enum BreakpointKind { phone, tablet, desktop }

/// 현재 MediaQuery 너비 기준으로 BreakpointKind를 반환한다.
BreakpointKind breakpointOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 1024) return BreakpointKind.desktop;
  if (width >= 600) return BreakpointKind.tablet;
  return BreakpointKind.phone;
}

/// 그리드 구성 시 BreakpointKind 별 컬럼 수를 계산한다.
int gridColumnsOf(BreakpointKind kind) => switch (kind) {
      BreakpointKind.phone => 2,
      BreakpointKind.tablet => 3,
      BreakpointKind.desktop => 4,
    };

/// Responsive Framework builder. MaterialApp.builder에 전달한다.
Widget responsiveBuilder(BuildContext context, Widget? child) {
  return ResponsiveBreakpoints.builder(
    child: child ?? const SizedBox.shrink(),
    breakpoints: const [
      Breakpoint(start: 0, end: 599, name: MOBILE),
      Breakpoint(start: 600, end: 1023, name: TABLET),
      Breakpoint(start: 1024, end: double.infinity, name: DESKTOP),
    ],
  );
}
