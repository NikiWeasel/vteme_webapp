import 'package:go_router/go_router.dart';
import 'package:vteme_tg_miniapp/features/agreement/view/agreement_screen.dart';
import 'package:vteme_tg_miniapp/features/home/view/home_screen.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/schedule_screen.dart';

get router {
  return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            return const HomeScreen();
          },
          routes: [
            // Вложенный маршрут agreement
            GoRoute(
              path: '/user-agreement',
              builder: (context, state) => const AgreementScreen(),
            ),
          ],
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
      ],
      redirect: (context, state) {
        final uri = state.uri;
        if (uri.toString().contains('tgWebAppData')) {
          return '/home';
        }
        return null;
      });
}
