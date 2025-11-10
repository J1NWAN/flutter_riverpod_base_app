import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 입력값 검증 함수를 표현한다.
typedef FieldValidator = String? Function(String? value);

/// 단일 필드 상태.
class FieldState {
  final String value;
  final String? error;
  final FieldValidator? validator;
  final bool touched;

  const FieldState({
    this.value = '',
    this.error,
    this.validator,
    this.touched = false,
  });

  bool get isValid => error == null;

  FieldState copyWith({
    String? value,
    String? error,
    bool clearError = false,
    FieldValidator? validator,
    bool? touched,
  }) {
    return FieldState(
      value: value ?? this.value,
      error: clearError ? null : (error ?? this.error),
      validator: validator ?? this.validator,
      touched: touched ?? this.touched,
    );
  }
}

/// 여러 필드 상태를 보관하는 폼 상태.
class FormState {
  final Map<String, FieldState> fields;

  const FormState({this.fields = const {}});

  bool get isValid => fields.values.every((f) => f.error == null);

  FieldState fieldFor(String key) => fields[key] ?? const FieldState();

  FormState copyWithField(String key, FieldState field) {
    final next = Map<String, FieldState>.from(fields)..[key] = field;
    return FormState(fields: next);
  }
}

/// Riverpod 기반 폼 컨트롤러.
/// - 언제 사용: 여러 TextField 값을 한 곳에서 관리/검증하고 싶을 때.
/// - 사용법:
///   ```dart
///   final controller = ref.read(formProvider.notifier);
///   controller.setInitial('email', '');
///   controller.registerValidator('email', Validators.required);
///   controller.setValue('email', 'foo@bar.com');
///   controller.validateAll();
///   if (ref.read(formProvider).isValid) { ... }
///   ```
class FormController extends StateNotifier<FormState> {
  FormController() : super(const FormState());

  void setInitial(String key, String value, {FieldValidator? validator}) {
    final current = state.fieldFor(key);
    final mergedValidator = validator ?? current.validator;
    state = state.copyWithField(
      key,
      FieldState(
        value: value,
        validator: mergedValidator,
        touched: false,
      ),
    );
  }

  void registerValidator(String key, FieldValidator validator) {
    final current = state.fieldFor(key);
    final error = current.touched ? validator(current.value) : null;
    state = state.copyWithField(
      key,
      current.copyWith(
        validator: validator,
        error: error,
        clearError: error == null,
      ),
    );
  }

  void setValue(String key, String value) {
    final current = state.fieldFor(key);
    final error = current.validator?.call(value);
    state = state.copyWithField(
      key,
      current.copyWith(
        value: value,
        error: error,
        touched: true,
        clearError: error == null,
      ),
    );
  }

  String getValue(String key) => state.fieldFor(key).value;

  String? getError(String key) => state.fieldFor(key).error;

  bool validateAll() {
    var nextState = state;
    for (final entry in state.fields.entries) {
      final validator = entry.value.validator;
      final error = validator?.call(entry.value.value);
      nextState = nextState.copyWithField(
        entry.key,
        entry.value.copyWith(
          error: error,
          touched: true,
          clearError: error == null,
        ),
      );
    }
    state = nextState;
    return state.isValid;
  }

  void reset() {
    state = const FormState();
  }
}

/// 글로벌 Provider: ref.watch(formProvider)로 상태를 구독한다.
final formProvider =
    StateNotifierProvider<FormController, FormState>((ref) => FormController());
