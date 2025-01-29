import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = "https://api.calorieninjas.com/v1/nutrition";
const String apiKey = "sJA5BDqLJ+VReWp6OtRUKQ==YxdNXHxOjRKreUNH";

class NutritionLogPage extends StatefulWidget {
  @override
  _NutritionLogPageState createState() => _NutritionLogPageState();
}

class _NutritionLogPageState extends State<NutritionLogPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _nutritionData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchNutritionData(String query) async {
    setState(() => _isLoading = true);
    final response = await http.get(
      Uri.parse('$apiUrl?query=$query'),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _nutritionData = List<Map<String, dynamic>>.from(data['items']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('savedNutrition');
    List<Map<String, dynamic>> savedItems = [];

    if (savedData != null) {
      savedItems = List<Map<String, dynamic>>.from(json.decode(savedData));
    }

    savedItems.add(item);
    await prefs.setString('savedNutrition', json.encode(savedItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Log')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter food items...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _fetchNutritionData(_controller.text),
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _nutritionData.length,
                itemBuilder: (context, index) {
                  final item = _nutritionData[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(
                        'Calories: ${item['calories']} kcal\n'
                            'Protein: ${item['protein_g']} g\n'
                            'Carbs: ${item['carbohydrates_total_g']} g\n'
                            'Fat: ${item['fat_total_g']} g',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () => _saveItem(item),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedItemsPage()),
                );
              },
              child: Text('View Saved Items'),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedItemsPage extends StatefulWidget {
  @override
  _SavedItemsPageState createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  List<Map<String, dynamic>> _savedItems = [];
  double _totalCalories = 0.0;
  double _totalProtein = 0.0;
  double _totalCarbs = 0.0;
  double _totalFat = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('savedNutrition');
    if (savedData != null) {
      setState(() {
        _savedItems = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
      _calculateTotals();
    }
  }

  void _calculateTotals() {
    double totalCalories = 0;
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;

    for (var item in _savedItems) {
      totalCalories += item['calories'];
      totalProtein += item['protein_g'];
      totalCarbs += item['carbohydrates_total_g'];
      totalFat += item['fat_total_g'];
    }

    setState(() {
      _totalCalories = totalCalories;
      _totalProtein = totalProtein;
      _totalCarbs = totalCarbs;
      _totalFat = totalFat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Items')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _savedItems.length,
                itemBuilder: (context, index) {
                  final item = _savedItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(
                        'Calories: ${item['calories']} kcal\n'
                            'Protein: ${item['protein_g']} g\n'
                            'Carbs: ${item['carbohydrates_total_g']} g\n'
                            'Fat: ${item['fat_total_g']} g',
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Total Calories: ${_totalCalories.toStringAsFixed(0)} kcal'),
            Text('Total Protein: ${_totalProtein.toStringAsFixed(1)} g'),
            Text('Total Carbs: ${_totalCarbs.toStringAsFixed(1)} g'),
            Text('Total Fat: ${_totalFat.toStringAsFixed(1)} g'),
          ],
        ),
      ),
    );
  }
}