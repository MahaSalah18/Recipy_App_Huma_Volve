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
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 226, 227, 227),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 148, 76, 17),
          surface: const Color.fromARGB(255, 226, 227, 227),
        ),
      ),
      home: const RecipeHomeScreen(),
    );
  }
}
