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

  void resetPlanDueToMissedDays(
    UserModel user,
    int daysPassed,
    int daysMissed,
  ) {
    // Implementation logic
  }
}

final planProvider = NotifierProvider<PlanNotifier, double>(() {
  return PlanNotifier();
});
