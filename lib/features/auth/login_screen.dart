import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../app/forms/form_state.dart' as form;
import '../../core/validators.dart';
import '../../routes.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/app_toast.dart';
import '../../ui/button.dart';
import '../../ui/forms/form_field_adapter.dart';
import '../../ui/text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('다시 만나 반가워요 👋', style: theme.textTheme.headlineSmall),
                Gap(tokens.gapSmall),
                Text(
                  '등록된 계정으로 로그인해 주세요.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap(tokens.gapXLarge),
                FormFieldAdapter(
                  fieldKey: 'loginEmail',
                  validator:
                      (value) =>
                          Validators.required(value) ?? Validators.email(value),
                  builder: (context, value, error, onChanged, controller) {
                    return AppTextField(
                      controller: controller,
                      label: '이메일',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      errorText: error,
                      onChanged: onChanged,
                    );
                  },
                ),
                Gap(tokens.gapLarge),
                FormFieldAdapter(
                  fieldKey: 'loginPassword',
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
                      onChanged: onChanged,
                    );
                  },
                ),
                Gap(tokens.gapLarge),
                AppButton.primary(
                  label: '로그인',
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
                    final email = controller.getValue('loginEmail');
                    AppToast.show(
                      context,
                      message: '$email 님, 환영합니다!',
                      type: AppToastType.success,
                    );
                  },
                ),
                Gap(tokens.gapMedium),
                AppButton.text(
                  label: '계정이 없으신가요? 회원가입',
                  onPressed: () => context.go(AppRoutes.signup),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
