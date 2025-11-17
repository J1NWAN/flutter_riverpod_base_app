import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base_app/ui/navigation/app_destinations.dart';
import 'package:flutter_riverpod_base_app/ui/scaffold.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      centerTitle: true,
      title: 'Main Screen',
      leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.go('/settings');
          },
        ),
      ],
      destinations: appDestinations,
      currentIndex: 0,
      onDestinationSelected: (index) {
        if (index == 0) {
          return;
        }
        context.go(appDestinations[index].route);
      },
      child: Center(
        child: Text(
          'Welcome to the Main Screen!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
