class FoodGroup {
  final String groupName;
  final String description;

  FoodGroup({
    required this.groupName,
    required this.description,
  });

  factory FoodGroup.fromJson(Map<String, dynamic> json) {
    return FoodGroup(
      groupName: json['group_name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'description': description,
    };
  }
}

class FoodGroupResponse {
  final List<FoodGroup> foodGroups;

  FoodGroupResponse({
    required this.foodGroups,
  });

  factory FoodGroupResponse.fromJson(Map<String, dynamic> json) {
    var groupsList = json['food_groups'] as List? ?? [];
    List<FoodGroup> foodGroups =
        groupsList.map((group) => FoodGroup.fromJson(group)).toList();

    return FoodGroupResponse(
      foodGroups: foodGroups,
    );
  }
}
