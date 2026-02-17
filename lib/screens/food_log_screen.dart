import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/food_service.dart';
import '../core/theme.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  final _searchController = TextEditingController();
  List<RecordModel> _searchResults = [];
  bool _isLoading = false;

  void _search(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    final results = await FoodService.searchFoods(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _log(RecordModel food) async {
    // Defaulting to 1 unit for now
    await FoodService.logFood(
      foodId: food.id,
      quantity: 1.0,
      date: DateTime.now(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged ${food.getStringValue('name')}")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Food"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Indian or Global food...",
                prefixIcon: const Icon(Icons.search, color: AppColors.saffron),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _search,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(color: AppColors.saffron),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final food = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(food.getStringValue('name')),
                      subtitle: Text(
                        "${food.getIntValue('calories')} kcal • ${food.getStringValue('unit')}",
                      ),
                      trailing: const Icon(
                        Icons.add_circle,
                        color: AppColors.teal,
                      ),
                      onTap: () => _log(food),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
