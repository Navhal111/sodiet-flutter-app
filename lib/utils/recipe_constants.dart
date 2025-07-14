import 'package:sodiet/utils/images.dart';

class RecipeConstants {
  static List<String> categories = [
    'Custom',
    'Masala karela',
    'Rice',
    'Chicken Korma',
    'Tomato Rice',
  ];

  static List<Map<String, dynamic>> recipes = [
    {
      'id': '1',
      'name': 'Masala Karela recipe',
      'category': 'Masala karela',
      'description': 'D2A',
      'calories': 81,
      'cookingTime': 25,
      'imagePath': MyImages.food1,
    },
    {
      'id': '2',
      'name': 'Spicy Tomato Rice (Recipe)',
      'category': 'Tomato Rice',
      'description': 'E1B',
      'calories': 81,
      'cookingTime': 25,
      'imagePath': MyImages.food2,
    },
    {
      'id': '3',
      'name': 'Masala Karela recipe',
      'category': 'Masala karela',
      'description': 'D2A',
      'calories': 81,
      'cookingTime': 25,
      'imagePath': MyImages.food1,
    },
    {
      'id': '4',
      'name': 'Spicy Tomato Rice (Recipe)',
      'category': 'Tomato Rice',
      'description': 'E1B',
      'calories': 81,
      'cookingTime': 25,
      'imagePath': MyImages.food2,
    },
    {
      'id': '5',
      'name': 'Chicken Korma Special',
      'category': 'Chicken Korma',
      'description': 'A1C',
      'calories': 120,
      'cookingTime': 45,
      'imagePath': MyImages.food1,
    },
    {
      'id': '6',
      'name': 'Basmati Rice Delight',
      'category': 'Rice',
      'description': 'B2D',
      'calories': 95,
      'cookingTime': 20,
      'imagePath': MyImages.food2,
    },
  ];

  static List<Map<String, dynamic>> getRecipesByCategory(String category) {
    if (category == 'Custom') {
      return recipes;
    }
    return recipes.where((recipe) => recipe['category'] == category).toList();
  }
}
