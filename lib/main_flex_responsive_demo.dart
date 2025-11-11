import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/demo/demo_app.dart';

/// 기존 main.dart를 건드리지 않고 데모를 실행하기 위한 entry point.
void main() {
  runApp(const ProviderScope(child: DemoApp()));
}
