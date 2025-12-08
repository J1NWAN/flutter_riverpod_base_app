import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/responsive/app_responsive.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/card.dart';
import '../../ui/navigation/app_destinations.dart';
import '../../ui/scaffold.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final bp = breakpointOf(context);

    return AppScaffold(
      title: '',
      destinations: appDestinations,
      currentIndex: 0,
      showNavigation: false,
      showDefaultSearchAction: false,
      showDefaultSettingsAction: false,
      onDestinationSelected: (_) {},
      child: Center(
        child: ListView(
          children: [
            Text(
              '알림 설정',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: bp == BreakpointKind.phone ? null : 22,
              ),
            ),
            SizedBox(height: tokens.gapSmall),
            AppCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(
                horizontal: tokens.gapMedium,
                vertical: tokens.gapSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('전체 알림', style: theme.textTheme.bodyMedium),
                  CupertinoSwitch(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() => _isChecked = value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
