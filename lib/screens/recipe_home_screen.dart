import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/ricepe_card.dart';

class RecipeHomeScreen extends StatefulWidget {
  const RecipeHomeScreen({super.key});

  @override
  State<RecipeHomeScreen> createState() => _RecipeHomeScreenState();
}

class _RecipeHomeScreenState extends State<RecipeHomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  int _selectedNavIndex = 0;
  String _selectedCategory = 'Seafood';
  String _searchQuery = '';

  List<Meal> _meals = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _categories = [
    'Seafood',
    'Beef',
    'Chicken',
    'Dessert',
    'Lamb',
    'Misc',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMeals();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final meals = await _apiService.getMealsByCategory(_selectedCategory);
      if (!mounted) return;

      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _meals = [];
        _isLoading = false;
        _errorMessage = 'Failed to load recipes. Please try again.';
      });
    }
  }

  List<Meal> get _filteredMeals {
    if (_searchQuery.isEmpty) return _meals;

    return _meals
        .where((meal) => meal.strMeal.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _onCategorySelected(String category) {
    if (category == _selectedCategory) return;

    setState(() {
      _selectedCategory = category;
      _searchController.clear();
      _searchQuery = '';
    });
    _fetchMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: _selectedCategory),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(
            hintText: 'Search in $_selectedCategory',
            controller: _searchController,
          ),
          _buildCategoryRow(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedNavIndex,
        onItemTapped: (index) => setState(() => _selectedNavIndex = index),
      ),
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () => _onCategorySelected(category),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryBrown
                      : AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBrown),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _fetchMeals,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final meals = _filteredMeals;

    if (meals.isEmpty) {
      return const Center(
        child: Text(
          'No recipes found',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
        childAspectRatio: 0.72,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        return RecipeCard(
          meal: meals[index],
          onTap: () {},
        );
      },
    );
  }
}
