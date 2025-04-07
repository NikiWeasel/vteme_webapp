import 'package:go_router/go_router.dart';
import 'package:vteme_tg_miniapp/features/home/view/home_screen.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/schedule_screen.dart';

get router {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // GoRoute(
      //   path: '/schedule',
      //   builder: (context, state) {
      //     final data = state.extra as Map<String, dynamic>?;
      //     print('router. ${context.read<ActionsAppointmentBloc>()}');
      //     return ScheduleScreen(
      //       user: data?['user'],
      //       showDialogImidiatly: data?['showDialogImidiatly'],
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/notifications',
      //   builder: (context, state) {
      //     return const NotificationsScreen();
      //   },
      // ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/schedule_appo',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return ScheduleScreen(
            employee: data?['employee'],
            service: data?['service'],
          );
        },
      ),
      // GoRoute(
      //   path: '/settings',
      //   builder: (context, state) {
      //     return const SettingsScreen();
      //   },
      // ),
      // GoRoute(
      //   path: '/login',
      //   builder: (context, state) {
      //     return const LoginScreen();
      //   },
      // ),
      // GoRoute(
      //   path: '/app',
      //   builder: (context, state) {
      //     return const App();
      //   },
      // ),
      // GoRoute(
      //   path: '/splash',
      //   builder: (context, state) {
      //     return const SplashScreen();
      //   },
      // ),
      // BottomNavigationBar
    ],
  );
}
