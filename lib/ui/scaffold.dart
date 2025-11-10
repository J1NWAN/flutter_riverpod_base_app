import 'package:flutter/material.dart';

import '../theme/tokens.dart';

class AppDestination {
  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
    this.floatingActionButton,
    this.showAppBar = true,
    this.showNavigation = true,
    super.key,
  });

  final String title;
  final List<AppDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool showNavigation;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= tokens.breakpointDesktop;
        final isTablet =
            width >= tokens.breakpointTablet &&
            width < tokens.breakpointDesktop;

        if (isDesktop) {
          return Scaffold(
            appBar: showAppBar ? AppBar(title: Text(title)) : null,
            floatingActionButton: floatingActionButton,
            body: Row(
              children: [
                if (showNavigation)
                  SizedBox(
                    width: tokens.navigationRailWidth,
                    child: _NavigationRailShell(
                      destinations: destinations,
                      currentIndex: currentIndex,
                      onDestinationSelected: onDestinationSelected,
                      extended: true,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.gapXLarge),
                    child: SafeArea(child: child),
                  ),
                ),
              ],
            ),
          );
        }

        if (isTablet) {
          return Scaffold(
            appBar: showAppBar ? AppBar(title: Text(title)) : null,
            floatingActionButton: floatingActionButton,
            body: Row(
              children: [
                if (showNavigation)
                  _NavigationRailShell(
                    destinations: destinations,
                    currentIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    extended: false,
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(tokens.gapLarge),
                    child: SafeArea(child: child),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: showAppBar ? AppBar(title: Text(title)) : null,
          floatingActionButton: floatingActionButton,
          body: Padding(
            padding: EdgeInsets.all(tokens.gapLarge),
            child: SafeArea(child: child),
          ),
          bottomNavigationBar:
              showNavigation
                  ? NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations:
                        destinations
                            .map(
                              (destination) => NavigationDestination(
                                icon: Icon(destination.icon),
                                selectedIcon: Icon(destination.selectedIcon),
                                label: destination.label,
                              ),
                            )
                            .toList(),
                  )
                  : null,
        );
      },
    );
  }
}

class _NavigationRailShell extends StatelessWidget {
  const _NavigationRailShell({
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.extended,
  });

  final List<AppDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      labelType:
          extended
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.selected,
      extended: extended,
      destinations:
          destinations
              .map(
                (destination) => NavigationRailDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: Text(destination.label),
                ),
              )
              .toList(),
    );
  }
}
