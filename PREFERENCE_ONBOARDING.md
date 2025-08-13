# Preference Onboarding Feature

This feature allows users to view and manage their food preferences based on meal types (Breakfast, Lunch, Dinner, Snacks).

## Files Created/Modified

### Models

- `lib/model/preference_model.dart` - Data models for preference API responses

### Controllers

- `lib/controller/preference/preference_onboarding_controller.dart` - Main controller for preference management

### Widgets

- `lib/view/widgets/preference/api_combinations_widget.dart` - Widget to display API combinations
- `lib/view/widgets/preference/combination_form_widget.dart` - Updated to support dynamic food options

### Updated Files

- `lib/view/screen/preference_onboarding_screen.dart` - Updated to use the new controller
- `lib/constant/appConstant.dart` - Added preference API endpoint
- `lib/helper/get_di.dart` - Added controller dependency injection

## API Integration

The controller fetches food combinations from:

```
GET /personalization/preferences?time={mealType}
```

Where `mealType` is one of: `breakfast`, `lunch`, `dinner`, `snacks`

### API Response Structure

```json
{
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
        }
      ],
      "total_items": 2
    }
  ],
  "total_preferences": 8,
  "total_combinations": 3,
  "message": "Found 8 preferences in 3 combinations"
}
```

## Features

1. **Meal Type Tabs**: Switch between different meal types
2. **API Combinations Display**: Shows existing combinations from the API
3. **Add Custom Combinations**: Users can add their own food combinations
4. **Dynamic Food Options**: Food dropdown is populated from API data when available
5. **Save Preferences**: Save user's custom combinations

## Usage

1. The controller is automatically initialized when the screen loads
2. It fetches preferences for the default meal type (Breakfast)
3. Users can switch between meal types using tabs
4. API combinations are displayed in a dedicated section
5. Users can add their own combinations using the form
6. The food dropdown shows API foods when available, falls back to default options

## Controller Methods

- `getPreferences()` - Fetch preferences from API based on selected meal type
- `onMealTypeChanged(String)` - Handle meal type tab changes
- `onAddCombination()` - Add a new combination
- `onDeleteCombination(int)` - Delete a combination
- `savePreferences()` - Save user preferences
- `getAvailableFoodOptions()` - Get food options from API or defaults
- `getFilteredCombinations()` - Get combinations for current meal type
