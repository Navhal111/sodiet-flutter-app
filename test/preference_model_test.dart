import 'package:flutter_test/flutter_test.dart';
import 'package:sodiet/model/preference_model.dart';

void main() {
  group('Preference Model Tests', () {
    test('PreferenceFood.fromJson should parse correctly', () {
      final json = {
        'ID': 1,
        'Food_Name': 'Brown Rice',
        'Food_Qty': 100,
        'Time': 'lunch',
        'Description': 'Steamed',
        'Recipe_weight': 6,
        'UID': 'static_user_001',
        'Pkey': 48
      };

      final food = PreferenceFood.fromJson(json);

      expect(food.id, 1);
      expect(food.foodName, 'Brown Rice');
      expect(food.foodQty, 100);
      expect(food.time, 'lunch');
      expect(food.description, 'Steamed');
      expect(food.recipeWeight, 6);
      expect(food.uid, 'static_user_001');
      expect(food.pkey, 48);
    });

    test('PreferenceCombination.fromJson should parse correctly', () {
      final json = {
        'combination_id': 1,
        'foods': [
          {
            'ID': 1,
            'Food_Name': 'Brown Rice',
            'Food_Qty': 100,
            'Time': 'lunch',
            'Description': 'Steamed',
            'Recipe_weight': 6,
            'UID': 'static_user_001',
            'Pkey': 48
          }
        ],
        'total_items': 1
      };

      final combination = PreferenceCombination.fromJson(json);

      expect(combination.combinationId, 1);
      expect(combination.foods.length, 1);
      expect(combination.totalItems, 1);
      expect(combination.foods[0].foodName, 'Brown Rice');
    });

    test('PreferenceResponse.fromJson should parse correctly', () {
      final json = {
        'combinations': [
          {
            'combination_id': 1,
            'foods': [
              {
                'ID': 1,
                'Food_Name': 'Brown Rice',
                'Food_Qty': 100,
                'Time': 'lunch',
                'Description': 'Steamed',
                'Recipe_weight': 6,
                'UID': 'static_user_001',
                'Pkey': 48
              }
            ],
            'total_items': 1
          }
        ],
        'total_preferences': 8,
        'total_combinations': 3,
        'message': 'Found 8 preferences in 3 combinations'
      };

      final response = PreferenceResponse.fromJson(json);

      expect(response.combinations.length, 1);
      expect(response.totalPreferences, 8);
      expect(response.totalCombinations, 3);
      expect(response.message, 'Found 8 preferences in 3 combinations');
    });
  });
}
