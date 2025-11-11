import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../app/forms/form_state.dart' as form;
import '../../core/security/password_cipher.dart';
import '../../core/validators.dart';
import '../../routes.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/app_toast.dart';
import '../../ui/button.dart';
import '../../ui/forms/form_field_adapter.dart';
import '../../ui/text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(form.formProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(tokens.gapXLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('계정을 새로 만들어요 ✨', style: theme.textTheme.headlineSmall),
                Gap(tokens.gapSmall),
                Text(
                  '기본 정보를 입력하고 시작해 보세요.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap(tokens.gapXLarge),
                FormFieldAdapter(
                  fieldKey: 'signupName',
                  validator:
                      (value) =>
                          Validators.required(value) ??
                          Validators.minLength(value, 2),
                  builder: (context, value, error, onChanged, controller) {
                    return AppTextField(
                      controller: controller,
                      label: '이름',
                      hint: '홍길동',
                      errorText: error,
                      onChanged: onChanged,
                    );
                  },
                ),
                Gap(tokens.gapLarge),
                FormFieldAdapter(
                  fieldKey: 'signupEmail',
                  validator:
                      (value) =>
                          Validators.required(value) ?? Validators.email(value),
                  builder: (context, value, error, onChanged, controller) {
                    return AppTextField(
                      controller: controller,
                      label: '이메일',
                      keyboardType: TextInputType.emailAddress,
                      hint: 'you@example.com',
                      errorText: error,
                      onChanged: onChanged,
                    );
                  },
                ),
                Gap(tokens.gapLarge),
                FormFieldAdapter(
                  fieldKey: 'signupPassword',
                  validator:
                      (value) =>
                          Validators.required(value) ??
                          Validators.minLength(value, 8),
                  builder: (context, value, error, onChanged, controller) {
                    return AppTextField(
                      controller: controller,
                      label: '비밀번호',
                      obscureText: true,
                      errorText: error,
                      onChanged: (val) {
                        onChanged(val);
                        final confirm = ref
                            .read(form.formProvider)
                            .fieldFor('signupConfirmPassword');
                        if (confirm.value.isNotEmpty) {
                          ref
                              .read(form.formProvider.notifier)
                              .setValue('signupConfirmPassword', confirm.value);
                        }
                      },
                    );
                  },
                ),
                Gap(tokens.gapLarge),
                FormFieldAdapter(
                  fieldKey: 'signupConfirmPassword',
                  validator: (value) {
                    final password =
                        ref
                            .read(form.formProvider)
                            .fieldFor('signupPassword')
                            .value;
                    return Validators.required(value) ??
                        Validators.equals(
                          value,
                          password,
                          message: '비밀번호가 일치하지 않습니다.',
                        );
                  },
                  builder: (context, value, error, onChanged, controller) {
                    return AppTextField(
                      controller: controller,
                      label: '비밀번호 확인',
                      obscureText: true,
                      errorText: error,
                      onChanged: onChanged,
                    );
                  },
                ),
                Gap(tokens.gapXLarge),
                AppButton.primary(
                  label: '회원가입',
                  onPressed: () {
                    final controller = ref.read(form.formProvider.notifier);
                    final isValid = controller.validateAll();
                    if (!isValid) {
                      AppToast.show(
                        context,
                        message: '입력 값을 확인해 주세요.',
                        type: AppToastType.error,
                      );
                      return;
                    }
                    final name = controller.getValue('signupName');
                    final password = PasswordCipher.hash(
                      controller.getValue('signupPassword'),
                    );

                    AppToast.show(
                      context,
                      message: '$name 님, 가입이 완료되었습니다!\n(해시된 비밀번호: $password)',
                      type: AppToastType.success,
                    );
                  },
                ),
                Gap(tokens.gapMedium),
                AppButton.text(
                  label: '이미 계정이 있으신가요? 로그인',
                  onPressed: () => context.go(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
