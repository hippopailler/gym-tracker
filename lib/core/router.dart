import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/calendar_screen.dart';
import '../features/calendar/session_edit_screen.dart';
import '../features/exercises/exercises_screen.dart';
import '../features/exercises/group_exercises_screen.dart';
import '../features/home/home_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/session/active_session_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/templates/template_edit_screen.dart';
import '../features/templates/templates_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/templates',
            builder: (context, state) => const TemplatesScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final idParam = state.uri.queryParameters['id'];
                  return TemplateEditScreen(
                    templateId: idParam == null ? null : int.tryParse(idParam),
                  );
                },
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/exercises',
            builder: (context, state) => const ExercisesScreen(),
            routes: [
              GoRoute(
                path: ':slug',
                builder: (context, state) => GroupExercisesScreen(
                  slug: state.pathParameters['slug']!,
                ),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/progress',
            builder: (context, state) => const ProgressScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/session',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: ActiveSessionScreen(),
      ),
    ),
    GoRoute(
      path: '/history/edit/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SessionEditScreen(
        sessionId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class _AppShell extends StatelessWidget {
  const _AppShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Templates',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Exercices',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendrier',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progression',
          ),
        ],
      ),
    );
  }
}
