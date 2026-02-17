import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/user_model.dart';

class AIService {
  static const String _apiKey =
      'REPLACE_WITH_YOUR_GEMINI_API_KEY'; // Use Google AI Studio for free key

  static Future<String> generateDietPlan({
    required UserModel user,
    required double targetCalories,
    required String? specialEvent,
  }) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

      String prompt =
          """
      Create a detailed 1-day Indian diet plan for a user with the following profile:
      Age: ${user.age}, Weight: ${user.weight}kg, Goal: Lose weight to ${user.goalWeight}kg.
      Target Daily Calories: ${targetCalories.round()} kcal.
      Special Event today: ${specialEvent ?? 'None'}.
      
      Include common Indian foods like Poha, Idli, Dal, Paneer, etc. 
      If there is a special event like a wedding or festival, adjust the breakfast and lunch to be lighter to accommodate a slightly heavier but healthy festive dinner.
      Structure it as: Breakfast, Mid-morning snack, Lunch, Evening Snack, Dinner.
      Format: Text with bullet points.
      """;

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text ?? "Could not generate plan.";
    } catch (e) {
      return "AI Service Error: $e. Please ensure API key is valid.";
    }
  }
}
