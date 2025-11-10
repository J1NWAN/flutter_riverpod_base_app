import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/validators.dart'; // ignore: unused_import
import '../../app/forms/form_state.dart' as form;

/// FormController와 TextField를 연결하는 어댑터.
/// - 언제 사용: 공통 TextField를 그대로 쓰면서 값/검증을 Riverpod으로 관리하고 싶을 때.
/// - 사용법:
///   ```dart
///   FormFieldAdapter(
///     fieldKey: 'email',
///     validator: (v) => Validators.required(v) ?? Validators.email(v),
///     builder: (ctx, value, error, onChanged, controller) {
///       return CommonTextField(
///         label: '이메일',
///         controller: controller,
///         errorText: error,
///         onChanged: onChanged,
///       );
///     },
///   );
///   ref.read(formProvider.notifier).validateAll();
///   if (ref.read(formProvider).isValid) { ... }
///   ```
class FormFieldAdapter extends ConsumerStatefulWidget {
  final String fieldKey;
  final Widget Function(
    BuildContext context,
    String value,
    String? error,
    ValueChanged<String> onChanged,
    TextEditingController controller,
  ) builder;
  final form.FieldValidator? validator;

  const FormFieldAdapter({
    super.key,
    required this.fieldKey,
    required this.builder,
    this.validator,
  });

  @override
  ConsumerState<FormFieldAdapter> createState() => _FormFieldAdapterState();
}

class _FormFieldAdapterState extends ConsumerState<FormFieldAdapter> {
  late final TextEditingController _controller;
  VoidCallback? _controllerListener;
  ProviderSubscription<form.FormState>? _subscription;

  @override
  void initState() {
    super.initState();
    final initialValue =
        ref.read(form.formProvider).fieldFor(widget.fieldKey).value;
    _controller = TextEditingController(text: initialValue);

    _controllerListener = () {
      ref.read(form.formProvider.notifier).setValue(
            widget.fieldKey,
            _controller.text,
          );
    };
    _controller.addListener(_controllerListener!);

    Future.microtask(() {
      final notifier = ref.read(form.formProvider.notifier);
      notifier.setInitial(widget.fieldKey, _controller.text);
      if (widget.validator != null) {
        notifier.registerValidator(widget.fieldKey, widget.validator!);
      }
    });

    _subscription = ref.listenManual<form.FormState>(
      form.formProvider,
      (previous, next) {
        final value = next.fieldFor(widget.fieldKey).value;
        if (_controller.text != value) {
          _controller.value = TextEditingValue(
            text: value,
            selection: TextSelection.collapsed(offset: value.length),
          );
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant FormFieldAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fieldKey != oldWidget.fieldKey) {
      final value =
          ref.read(form.formProvider).fieldFor(widget.fieldKey).value;
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
      ref.read(form.formProvider.notifier).setInitial(widget.fieldKey, value);
    }
    if (widget.validator != oldWidget.validator && widget.validator != null) {
      ref
          .read(form.formProvider.notifier)
          .registerValidator(widget.fieldKey, widget.validator!);
    }
  }

  @override
  void dispose() {
    if (_controllerListener != null) {
      _controller.removeListener(_controllerListener!);
    }
    _subscription?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form.FormState formState = ref.watch(form.formProvider);
    final fieldState = formState.fieldFor(widget.fieldKey);
    final value = fieldState.value;
    final error = fieldState.error;

    return widget.builder(
      context,
      value,
      error,
      (newValue) =>
          ref
              .read(form.formProvider.notifier)
              .setValue(widget.fieldKey, newValue),
      _controller,
    );
  }
}
