import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBase pb = PocketBase(
    'https://fitkarma-backend-production.up.railway.app',
  ); // User should update this with their Railway URL

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
