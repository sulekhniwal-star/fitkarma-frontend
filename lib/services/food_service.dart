import 'package:pocketbase/pocketbase.dart';
import '../services/pocketbase_service.dart';

class FoodService {
  static Future<List<RecordModel>> searchFoods(String query) async {
    return await PocketBaseService.pb
        .collection('foods')
        .getList(filter: 'name ~ "$query"')
        .then((value) => value.items);
  }

  static Future<void> logFood({
    required String foodId,
    required double quantity,
    required DateTime date,
  }) async {
    final userId = PocketBaseService.pb.authStore.model?.id;
    if (userId == null) return;

    await PocketBaseService.pb
        .collection('food_logs')
        .create(
          body: {
            'user': userId,
            'food': foodId,
            'quantity': quantity,
            'date': date.toIso8601String(),
          },
        );
  }

  static Future<List<RecordModel>> getDailyLogs(DateTime date) async {
    final userId = PocketBaseService.pb.authStore.model?.id;
    if (userId == null) return [];

    final dateStr = date.toIso8601String().split('T')[0];
    return await PocketBaseService.pb
        .collection('food_logs')
        .getList(
          filter:
              'user = "$userId" && date >= "$dateStr 00:00:00" && date <= "$dateStr 23:59:59"',
          expand: 'food',
        )
        .then((value) => value.items);
  }
}
