import 'package:flutter/material.dart';

import '../scaffold.dart';
import '../../routes.dart';

const List<AppDestination> appDestinations = [
  AppDestination(
    label: 'Main',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    route: AppRoutes.main,
  ),
  AppDestination(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    route: AppRoutes.dashboard,
  ),
  AppDestination(
    label: 'Calendar',
    icon: Icons.event_note_outlined,
    selectedIcon: Icons.event_note,
    route: AppRoutes.calendar,
  ),
  AppDestination(
    label: 'Component',
    icon: Icons.copy_outlined,
    selectedIcon: Icons.copy,
    route: AppRoutes.component,
  ),
];
