import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBase pb = PocketBase(
    'https://fitkarma-frontend-production.up.railway.app',
  );

  static Future<bool> login(String email, String password) async {
    try {
      await pb.collection('users').authWithPassword(email, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    pb.authStore.clear();
  }

  static bool get isAuthenticated => pb.authStore.isValid;
}
