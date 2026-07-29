import 'package:flutter/material.dart';

import 'screens/recipe_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B4513)),
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      home: const RecipeHomeScreen(),
    );
  }
}
