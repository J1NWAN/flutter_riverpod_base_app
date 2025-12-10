import 'package:flutter/material.dart';
import 'package:flutter_riverpod_base_app/ui/scaffold.dart';

import '../../../ui/navigation/app_destinations.dart';

class OpenSourceLicenseScreen extends StatelessWidget {
  const OpenSourceLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final license = [
      {'label': 'LICENSE 1', 'onTap': () {}},
      {'label': 'LICENSE 2', 'onTap': () {}},
      {'label': 'LICENSE 3', 'onTap': () {}},
      {'label': 'LICENSE 4', 'onTap': () {}},
      {'label': 'LICENSE 5', 'onTap': () {}},
      {'label': 'LICENSE 6', 'onTap': () {}},
      {'label': 'LICENSE 7', 'onTap': () {}},
      {'label': 'LICENSE 8', 'onTap': () {}},
      {'label': 'LICENSE 9', 'onTap': () {}},
      {'label': 'LICENSE 10', 'onTap': () {}},
    ];

    return AppScaffold(
      title: '오픈소스 라이선스',
      centerTitle: true,
      destinations: appDestinations,
      currentIndex: 0,
      showNavigation: false,
      showDefaultSearchAction: false,
      showDefaultSettingsAction: false,
      onDestinationSelected: (_) {},
      child: ListView.builder(
        itemCount: license.length,
        itemBuilder:
            (context, index) => _LicenseTile(
              label: license[index]['label'] as String,
              onTap: license[index]['onTap'] as VoidCallback,
              textStyle: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
      ),
    );
  }
}

class _LicenseTile extends StatelessWidget {
  const _LicenseTile({
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
