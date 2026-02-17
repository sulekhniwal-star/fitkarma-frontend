import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/glass_card.dart';
import '../core/theme.dart';
import '../screens/food_log_screen.dart';
import '../screens/add_event_screen.dart';
import '../services/ai_service.dart';
import '../models/user_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String aiPlan = "Loading your healthy Indian diet plan...";

  // Dummy data for demonstration
  final user = UserModel(
    id: '1',
    email: 'user@example.com',
    height: 175,
    weight: 85,
    age: 28,
    goalWeight: 75,
    targetDays: 60,
    activityLevel: 'moderate',
  );

  @override
  void initState() {
    super.initState();
    _fetchAIPlan();
  }

  Future<void> _fetchAIPlan() async {
    // In a real app, this would use calculated targets and DB events
    final plan = await AIService.generateDietPlan(
      user: user,
      targetCalories: 2100,
      specialEvent: "Holi Festival",
    );
    setState(() {
      aiPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.deepTeal],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Namaste, Fitness Buddy!",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "Let's reach your target in 58 days.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: AppColors.saffron,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Calorie Progress
                GlassCard(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1,250",
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppColors.saffron,
                                    fontSize: 40,
                                  ),
                            ),
                            const Text("Calories Consumed"),
                            const Text(
                              "Goal: 2,100 kcal",
                              style: TextStyle(color: AppColors.gold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: 1250 / 2100,
                          strokeWidth: 10,
                          color: AppColors.saffron,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // AI Diet Plan
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        context,
                        "Log Food",
                        Icons.restaurant,
                        AppColors.saffron,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const FoodLogScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _actionButton(
                        context,
                        "Special Day",
                        Icons.celebration,
                        AppColors.teal,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const AddEventScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // AI Diet Plan
                Text(
                  "Your AI Diet Plan (Indian)",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                GlassCard(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Text(aiPlan, style: const TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 20),

                // Challenges
                Text(
                  "Karma Challenges",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _challengeCard(
                        "Suryanamaskar 12x",
                        "50 XP",
                        Colors.orange,
                      ),
                      _challengeCard("No Sugar Today", "100 XP", Colors.teal),
                      _challengeCard("10k Steps", "30 XP", Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _challengeCard(String title, String xp, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(
            xp,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
