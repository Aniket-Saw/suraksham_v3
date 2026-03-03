import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/alerts_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/chatbot/presentation/chat_screen.dart';
import '../../features/simulation/presentation/simulation_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
    GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
    GoRoute(path: '/alerts', builder: (context, state) => const AlertsScreen()),
    GoRoute(
      path: '/simulation',
      builder: (context, state) => const SimulationScreen(),
    ),
  ],
);
