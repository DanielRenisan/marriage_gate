import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:marriage_gate/core/constants/app_colors.dart';
import 'core/utils/routes.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/client_token_provider.dart';

void main() {
  // Set status bar color to white and icons to dark for visibility
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark, // For Android
    statusBarBrightness: Brightness.light, // For iOS
  ));

  runApp(
    ProviderScope(
      observers: [],
      overrides: [],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger client token fetch at app launch
    ref.read(clientTokenProvider.future);

    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Matrimony App',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.lightText,
          surface: AppColors.kLightSurface,
          onSurface: AppColors.kLightText,
          error: AppColors.error,
          onError: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: AppColors.kLightText,
              displayColor: AppColors.kLightText,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.primary,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          secondary: AppColors.secondary,
          onSecondary: AppColors.lightText,
          surface: AppColors.kDarkSurface,
          onSurface: AppColors.kDarkText,
          error: AppColors.error,
          onError: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.kDarkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: AppColors.kDarkText,
              displayColor: AppColors.kDarkText,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondary,
            side: const BorderSide(color: AppColors.secondary, width: 2),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.primary,
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
      routerConfig: router,
    );
  }
}


// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeModeProvider);
//     final locale = ref.watch(localeProvider);
//     return MaterialApp.router(
//       title: 'Matrimony App',
//       theme: ThemeData(
//         colorScheme: ColorScheme(
//           brightness: Brightness.light,
//           primary: AppColors.primary,
//           onPrimary: Colors.white,
//           secondary: AppColors.secondary,
//           onSecondary: AppColors.lightText,
//           surface: AppColors.kLightSurface,
//           onSurface: AppColors.kLightText,
//           error: AppColors.error,
//           onError: Colors.white,
//         ),
//         useMaterial3: true,
//         scaffoldBackgroundColor: AppColors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//         ),
//         textTheme: ThemeData.light().textTheme.apply(
//               bodyColor: AppColors.kLightText,
//               displayColor: AppColors.kLightText,
//             ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             textStyle: const TextStyle(fontWeight: FontWeight.bold),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//           ),
//         ),
//         outlinedButtonTheme: OutlinedButtonThemeData(
//           style: OutlinedButton.styleFrom(
//             foregroundColor: AppColors.primary,
//             side: const BorderSide(color: AppColors.primary, width: 2),
//             textStyle: const TextStyle(fontWeight: FontWeight.bold),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//           ),
//         ),
//         inputDecorationTheme: const InputDecorationTheme(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.primary),
//           ),
//         ),
//         snackBarTheme: const SnackBarThemeData(
//           backgroundColor: AppColors.primary,
//           contentTextStyle: TextStyle(color: Colors.white),
//         ),
//       ),
//       darkTheme: ThemeData(
//         colorScheme: ColorScheme(
//           brightness: Brightness.dark,
//           primary: AppColors.primary,
//           onPrimary: AppColors.white,
//           secondary: AppColors.secondary,
//           onSecondary: AppColors.lightText,
//           surface: AppColors.kDarkSurface,
//           onSurface: AppColors.kDarkText,
//           error: AppColors.error,
//           onError: Colors.white,
//         ),
//         useMaterial3: true,
//         scaffoldBackgroundColor: AppColors.kDarkBackground,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//         ),
//         textTheme: ThemeData.dark().textTheme.apply(
//               bodyColor: AppColors.kDarkText,
//               displayColor: AppColors.kDarkText,
//             ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             textStyle: const TextStyle(fontWeight: FontWeight.bold),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//           ),
//         ),
//         outlinedButtonTheme: OutlinedButtonThemeData(
//           style: OutlinedButton.styleFrom(
//             foregroundColor: AppColors.secondary,
//             side: const BorderSide(color: AppColors.secondary, width: 2),
//             textStyle: const TextStyle(fontWeight: FontWeight.bold),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//           ),
//         ),
//         inputDecorationTheme: const InputDecorationTheme(
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.primary),
//           ),
//         ),
//         snackBarTheme: const SnackBarThemeData(
//           backgroundColor: AppColors.primary,
//           contentTextStyle: TextStyle(color: Colors.white),
//         ),
//       ),
//       themeMode: themeMode,
//       locale: locale,
//       supportedLocales: const [Locale('en'), Locale('ta')],
//       localizationsDelegates: [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       routerConfig: router,
//     );
// }