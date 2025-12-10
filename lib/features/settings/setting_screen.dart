import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/token/app_tokens.dart';
import '../../ui/button.dart';
import '../../ui/card.dart';
import '../../ui/navigation/app_destinations.dart';
import '../../ui/scaffold.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);

    return AppScaffold(
      destinations: appDestinations,
      currentIndex: 0,
      showNavigation: false,
      showDefaultSearchAction: false,
      showDefaultSettingsAction: false,
      onDestinationSelected: (_) {},
      maxContentWidth: 720,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(41, 43, 47, 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(79, 85, 93, 1),
                  size: 35,
                ),
              ),
              title: Text(
                '사용자 이름',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '프로필 및 계정 설정',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color.fromRGBO(120, 120, 128, 1),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Column(
              children: [
                AppCard(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingTile(
                        label: '언어',
                        onTap: () {},
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      _SettingTile(
                        label: '알림',
                        onTap: () => context.push('/setting/notification'),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      _SettingTile(
                        label: '화면 테마',
                        onTap: () => context.push('/setting/theme'),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: tokens.gapMedium),

            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.text(
                label: '오픈소스 라이선스 보기',
                onPressed: () => context.push('/setting/open-source-license'),
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.label,
    required this.onTap,
    this.textStyle,
  });

  final String label;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(label, style: textStyle),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color.fromRGBO(79, 85, 93, 1),
      ),
      onTap: onTap,
    );
  }
}
