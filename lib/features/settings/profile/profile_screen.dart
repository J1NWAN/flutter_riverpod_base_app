import 'package:flutter/material.dart';
import 'package:flutter_riverpod_base_app/ui/scaffold.dart';

import '../../../ui/navigation/app_destinations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'OOO님의 정보',
      centerTitle: true,
      destinations: appDestinations,
      currentIndex: 0,
      showNavigation: false,
      showDefaultSearchAction: false,
      showDefaultSettingsAction: false,
      onDestinationSelected: (_) {},
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(41, 43, 47, 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(79, 85, 93, 1),
                  size: 60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            leading: Text(
              '이름',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('OOO'),
                Icon(Icons.chevron_right, color: Color.fromRGBO(79, 85, 93, 1)),
              ],
            ),
            onTap: () {},
          ),

          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            leading: Text(
              '영문 이름',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('OOO'),
                Icon(Icons.chevron_right, color: Color.fromRGBO(79, 85, 93, 1)),
              ],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
