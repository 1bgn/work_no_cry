import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'di/injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6D28D9); // фиолетовый (можешь поменять)

    final lightScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    final baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: getIt<GoRouter>(),
      themeMode: ThemeMode.system, // подхватит системный светлый/тёмный режим
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: lightScheme.surface,
          foregroundColor: lightScheme.onSurface,
        ),

        cardTheme: CardThemeData(
        color: lightScheme.surfaceContainerHighest,
        shape: baseShape,
        elevation: 0,
      ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(shape: baseShape),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(shape: baseShape),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: const TextStyle(fontWeight: FontWeight.w700),
          titleMedium: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: darkScheme.surface,
          foregroundColor: darkScheme.onSurface,
        ),
        cardTheme: CardThemeData(
          color: darkScheme.surfaceContainerHighest,
          shape: baseShape,
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(shape: baseShape),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(shape: baseShape),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textTheme: ThemeData.dark().textTheme.copyWith(
          titleLarge: const TextStyle(fontWeight: FontWeight.w700),
          titleMedium: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
