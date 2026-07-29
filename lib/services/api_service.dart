import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal_model.dart';

class ApiService {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/filter.php?c=$category'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return MealsResponse.fromJson(data).meals;
  }
}
