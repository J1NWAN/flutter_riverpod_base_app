import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final log = Logger();

class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    assert(() {
      final name = provider.name ?? provider.runtimeType.toString();
      log.d('Provider $name updated: $newValue');
      return true;
    }());
  }
}
