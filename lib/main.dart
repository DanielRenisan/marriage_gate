import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/matches_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/welcome_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Registration Coming Soon!')),
    );
  }
}

// Custom color palette
const Color kPrimaryColor = Color(0xFFc3444a); // Warm Red
const Color kSecondaryColor = Color(0xFFf4c2c2); // Soft Pink
const Color kAccentColor = Color(0xFFFFD700); // Gold
const Color kErrorColor = Color(0xFFd32f2f); // Deep Red

// Light theme
const Color kLightBackground = Color(0xFFFFFFFF);
const Color kLightSurface = Color(0xFFF5F5F5);
const Color kLightText = Color(0xFF2e2e2e);

// Dark theme
const Color kDarkBackground = Color(0xFF1a1a1a);
const Color kDarkSurface = Color(0xFF2c2c2c);
const Color kDarkText = Color(0xFFe0e0e0);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
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
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Matrimony App',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: kPrimaryColor,
          onPrimary: Colors.white,
          secondary: kSecondaryColor,
          onSecondary: kLightText,
          background: kLightBackground,
          onBackground: kLightText,
          surface: kLightSurface,
          onSurface: kLightText,
          error: kErrorColor,
          onError: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: kLightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: kLightText,
              displayColor: kLightText,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryColor,
            side: const BorderSide(color: kPrimaryColor, width: 2),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: kPrimaryColor,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: kPrimaryColor,
          onPrimary: Colors.white,
          secondary: kSecondaryColor,
          onSecondary: kDarkText,
          background: kDarkBackground,
          onBackground: kDarkText,
          surface: kDarkSurface,
          onSurface: kDarkText,
          error: kErrorColor,
          onError: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: kDarkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: kDarkText,
              displayColor: kDarkText,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kAccentColor,
            side: const BorderSide(color: kAccentColor, width: 2),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: kPrimaryColor,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ta')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
