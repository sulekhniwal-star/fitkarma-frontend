class UserModel {
  final String id;
  final String email;
  final double? height; // in cm
  final double? weight; // in kg
  final int? age;
  final double? goalWeight;
  final int? targetDays;
  final String? activityLevel;

  final DateTime? created;

  UserModel({
    required this.id,
    required this.email,
    this.height,
    this.weight,
    this.age,
    this.goalWeight,
    this.targetDays,
    this.activityLevel,
    this.created,
  });

  factory UserModel.fromRecord(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      age: data['age'],
      goalWeight: data['goal_weight']?.toDouble(),
      targetDays: data['target_days'],
      activityLevel: data['activity_level'],
      created: data['created'] != null ? DateTime.parse(data['created']) : null,
    );
  }
}

class FitnessCalculator {
  static double calculateBMR(
    double weight,
    double height,
    int age,
    String gender,
  ) {
    if (gender.toLowerCase() == 'male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  static double calculateTDEE(double bmr, String activityLevel) {
    Map<String, double> multipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    return bmr * (multipliers[activityLevel] ?? 1.2);
  }

  static double calculateDailyCalories(
    double currentWeight,
    double targetWeight,
    int days,
    double tdee,
  ) {
    // 1kg fat is approx 7700 calories
    double totalWeightToLose = currentWeight - targetWeight;
    double totalDeficitNeeded = totalWeightToLose * 7700;
    double dailyDeficit = totalDeficitNeeded / days;
    return tdee - dailyDeficit;
  }
}
