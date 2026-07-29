class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String? strArea;
  final String? strCountry;

  const Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strArea,
    this.strCountry,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strArea: json['strArea'] as String?,
      strCountry: json['strCountry'] as String?,
    );
  }
}

class MealsResponse {
  final List<Meal> meals;

  const MealsResponse({required this.meals});

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    final mealsJson = json['meals'] as List<dynamic>?;

    return MealsResponse(
      meals: mealsJson
              ?.map((meal) => Meal.fromJson(meal as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
