// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

String _$calendarEventsHash() =>
    r'7f0f644d4dc7e7dbf569f0b28e3ce17f0d4f0b70';

@ProviderFor(calendarEvents)
final calendarEventsProvider =
    AutoDisposeProvider<Map<DateTime, List<CalendarEvent>>>.internal(
  calendarEvents,
  name: r'calendarEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalendarEventsRef
    = AutoDisposeProviderRef<Map<DateTime, List<CalendarEvent>>>;
