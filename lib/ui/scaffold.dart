import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/token/app_tokens.dart';
import '../../ui/appbar/app_top_bar.dart';
import 'search_bar.dart';

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
    this.title,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
    this.floatingActionButton,
    this.showAppBar = true,
    this.showNavigation = true,
    this.appBarActions,
    this.leading,
    this.centerTitle = false,
    this.bottom,
    this.showDefaultSearchAction = true,
    this.showDefaultSettingsAction = true,
    this.maxContentWidth,
    this.contentPadding,
    this.useSearchBar = false,
    this.searchController,
    this.searchHintText,
    this.searchPadding,
    this.searchTrailing,
    this.onSearchChanged,
    this.searchAutofocus = false,
    super.key,
  });

  // 앱바/탐색 관련
  final String? title;
  final List<AppDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;
  final Widget? floatingActionButton;
  final bool showAppBar;
  final bool showNavigation;
  final List<Widget>? appBarActions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final bool showDefaultSearchAction;
  final bool showDefaultSettingsAction;

  // 본문 레이아웃
  final double? maxContentWidth;
  final EdgeInsetsGeometry? contentPadding;

  // 검색바 옵션 (useSearchBar=true일 때 적용)
  final bool useSearchBar;
  final TextEditingController? searchController;
  final String? searchHintText;
  final EdgeInsetsGeometry? searchPadding;
  final Widget? searchTrailing;
  final ValueChanged<String>? onSearchChanged;
  final bool searchAutofocus;

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

        final defaultPadding =
            contentPadding ??
            EdgeInsets.all(
              isDesktop
                  ? tokens.gapXLarge
                  : isTablet
                  ? tokens.gapLarge
                  : tokens.gapMedium,
            );

        if (isDesktop) {
          return Scaffold(
            appBar: _buildAppBar(context, tokens),
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
                  child: _wrapContent(
                    child: child,
                    padding: defaultPadding,
                    maxWidth: maxContentWidth ?? 1080,
                  ),
                ),
              ],
            ),
          );
        }

        if (isTablet) {
          return Scaffold(
            appBar: _buildAppBar(context, tokens),
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
                  child: _wrapContent(
                    child: child,
                    padding: defaultPadding,
                    maxWidth: maxContentWidth ?? 720,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context, tokens),
          floatingActionButton: floatingActionButton,
          body: _wrapContent(
            child: child,
            padding: defaultPadding,
            maxWidth: maxContentWidth ?? double.infinity,
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

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    AppTokens tokens,
  ) {
    if (!showAppBar) return null;

    if (useSearchBar) {
      return AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: tokens.gapSmall),
          child: AppSearchBar(
            controller: searchController,
            hintText: searchHintText ?? '검색어를 입력하세요',
            padding: searchPadding ?? EdgeInsets.symmetric(horizontal: tokens.gapSmall),
            onChanged: onSearchChanged,
            trailing: searchTrailing,
            autofocus: searchAutofocus,
          ),
        ),
      );
    }

    return AppTopBar(
      centerTitle: centerTitle,
      leading: leading,
      title: title ?? '',
      actions: _buildAppBarActions(context),
      bottom: bottom,
    );
  }

  List<Widget>? _buildAppBarActions(BuildContext context) {
    if (useSearchBar && appBarActions == null) {
      return null;
    }
    if (appBarActions != null) {
      return appBarActions;
    }
    final actions = <Widget>[];
    final allowSearchAction = useSearchBar ? false : showDefaultSearchAction;
    final allowSettingsAction = useSearchBar ? false : showDefaultSettingsAction;

    if (allowSearchAction) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
        ),
      );
    }
    if (allowSettingsAction) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/setting'),
        ),
      );
    }
    return actions.isEmpty ? null : actions;
  }

  Widget _wrapContent({
    required Widget child,
    required EdgeInsetsGeometry padding,
    double? maxWidth,
  }) {
    final padded = Padding(padding: padding, child: SafeArea(child: child));
    if (maxWidth == null) return padded;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padded,
      ),
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
