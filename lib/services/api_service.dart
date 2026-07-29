import 'package:dio/dio.dart';

import '../models/meal_model.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://www.themealdb.com/api/json/v1/1',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await _dio.get(
      '/filter.php',
      queryParameters: {'c': category},
    );

    final data = response.data as Map<String, dynamic>;
    return MealsResponse.fromJson(data).meals;
  }
}
