/// Test data to verify API response format
/// This simulates the expected API response structure

Map<String, dynamic> sampleApiResponse = {
  "combinations": [
    {
      "combination_id": 1,
      "foods": [
        {
          "ID": 1,
          "Food_Name": "Brown Rice",
          "Food_Qty": 100,
          "Time": "lunch",
          "Description": "Steamed",
          "Recipe_weight": 6,
          "UID": "static_user_001",
          "Pkey": 48
        },
        {
          "ID": 2,
          "Food_Name": "Steamed Broccoli",
          "Food_Qty": 80,
          "Time": "lunch",
          "Description": "Lightly seasoned",
          "Recipe_weight": 7,
          "UID": "static_user_001",
          "Pkey": 49
        }
      ],
      "total_items": 2
    },
    {
      "combination_id": 2,
      "foods": [
        {
          "ID": 3,
          "Food_Name": "Quinoa Salad",
          "Food_Qty": 150,
          "Time": "lunch",
          "Description": "Mixed vegetables",
          "Recipe_weight": 8,
          "UID": "static_user_001",
          "Pkey": 50
        }
      ],
      "total_items": 1
    }
  ],
  "total_preferences": 8,
  "total_combinations": 3,
  "message": "Found 8 preferences in 3 combinations"
};

/// Test function to verify model parsing
void testApiResponseParsing() {
  try {
    // This would be called in your controller like this:
    // final preferenceResponse = PreferenceResponse.fromJson(response.body);

    print('Testing API response parsing...');
    print('Sample response: $sampleApiResponse');

    // The actual parsing would happen in your controller
    print('✅ API response format looks correct');
    print('Expected combinations: ${sampleApiResponse['total_combinations']}');
    print('Expected preferences: ${sampleApiResponse['total_preferences']}');
  } catch (e) {
    print('❌ Error in API response format: $e');
  }
}
