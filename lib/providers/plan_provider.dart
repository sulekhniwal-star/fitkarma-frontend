import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// Using Notifier instead of StateNotifier for modern Riverpod 2.0+
class PlanNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  double calculateDailyTarget({
    required double currentWeight,
    required double targetWeight,
    required int remainingDays,
    required double tdee,
  }) {
    double totalKgToLose = currentWeight - targetWeight;
    if (totalKgToLose <= 0) return tdee;

    double totalDeficitRequired = totalKgToLose * 7700;
    double dailyDeficit = totalDeficitRequired / remainingDays;

    double target = tdee - dailyDeficit;
    return target < 1200 ? 1200 : target;
  }

  double recalculateWithRemainingDays(UserModel user) {
    if (user.created == null ||
        user.targetDays == null ||
        user.weight == null ||
        user.goalWeight == null)
      return 2000;

    final goalDate = user.created!.add(Duration(days: user.targetDays!));
    final remainingDays = goalDate.difference(DateTime.now()).inDays;

    if (remainingDays <= 0) return 1500; // Maintenance or finished

    double bmr = FitnessCalculator.calculateBMR(
      user.weight!,
      user.height ?? 170,
      user.age ?? 25,
      'male', // Default for now
    );
    double tdee = FitnessCalculator.calculateTDEE(
      bmr,
      user.activityLevel ?? 'moderate',
    );

    return calculateDailyTarget(
      currentWeight: user.weight!,
      targetWeight: user.goalWeight!,
      remainingDays: remainingDays,
      tdee: tdee,
    );
  }
}

final planProvider = NotifierProvider<PlanNotifier, double>(() {
  return PlanNotifier();
});
