import 'package:go_router/go_router.dart';
import '../../presentation/screens/chat_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/matches_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/signup_screen_new.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/welcome_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreenNew(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/matches',
      builder: (context, state) => const MatchesScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
