import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 간단한 검색어 상태 Provider.
final searchQueryProvider = StateProvider<String>((ref) => '');
