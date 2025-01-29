import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home.dart';

class MealPlannerScreen extends StatefulWidget {
  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController excludeController = TextEditingController();

  String? dietGoal;
  String? dietType;

  String apiKey = "ae7438c9dbbe476ba6fe48222f8547da";
  String baseUrl = "https://api.spoonacular.com/mealplanner/generate";

  Map<String, dynamic>? mealPlan;
  bool isLoading = false;

  double calculateBMI(double weightKg, double heightCm) {
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  double calculateCalorieNeeds(double weightKg, double heightCm, String goal) {
    double bmr = 10 * weightKg + 6.25 * heightCm - 5 * 25 + 5;

    if (goal == 'bulking') {
      return bmr + 500;
    } else if (goal == 'cutting') {
      return bmr - 500;
    } else {
      return bmr;
    }
  }

  Future<void> fetchMealPlan(double calories, {String? diet, String? exclude}) async {
    setState(() {
      isLoading = true;
    });

    final Uri url = Uri.parse(baseUrl);
    final response = await http.get(url.replace(queryParameters: {
      'apiKey': apiKey,
      'timeFrame': 'day',
      'targetCalories': calories.toString(),
      'diet': diet,
      'exclude': exclude,
    }));

    if (response.statusCode == 200) {
      setState(() {
        mealPlan = json.decode(response.body);
      });
    } else {
      print("Failed to fetch meal plan: ${response.statusCode}");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner'),
        backgroundColor: Colors.blue[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height in cm'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight in kg'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Updated Goal Dropdown
              DropdownButton<String>(
                value: dietGoal, // Now it starts as null
                onChanged: (String? newValue) {
                  setState(() {
                    dietGoal = newValue!;
                  });
                },
                items: <String>['bulking', 'cutting']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
                hint: Text('Goal'), // Hint text
                isExpanded: true, // Ensure full width
              ),

              SizedBox(height: 10),

              // Updated Type Dropdown
              DropdownButton<String>(
                value: dietType, // Now it starts as null
                onChanged: (String? newValue) {
                  setState(() {
                    dietType = newValue!;
                  });
                },
                items: <String>['none', 'vegetarian', 'vegan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.capitalize()),
                  );
                }).toList(),
                hint: Text('Type'), // Hint text
                isExpanded: true, // Ensure full width
              ),

              SizedBox(height: 10),

              TextField(
                controller: excludeController,
                decoration: InputDecoration(
                  labelText: 'Ingredients to exclude (comma separated)',
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (heightController.text.isNotEmpty &&
                      weightController.text.isNotEmpty &&
                      dietGoal != null) {
                    double heightCm = double.parse(heightController.text);
                    double weightKg = double.parse(weightController.text);

                    double bmi = calculateBMI(weightKg, heightCm);
                    double calories = calculateCalorieNeeds(weightKg, heightCm, dietGoal!);

                    fetchMealPlan(
                      calories,
                      diet: dietType != 'none' ? dietType : null,
                      exclude: excludeController.text.isNotEmpty ? excludeController.text : null,
                    );

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          'Your BMI: ${bmi.toStringAsFixed(2)}\n'
                              'Daily Calorie Needs: ${calories.toStringAsFixed(0)}',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all required fields!')),
                    );
                  }
                },
                child: Text('Get Meal Plan'),
              ),

              SizedBox(height: 20),

              if (isLoading) ...[
                Center(child: CircularProgressIndicator()),
              ] else if (mealPlan != null) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: mealPlan!['meals'].length,
                  itemBuilder: (context, index) {
                    var meal = mealPlan!['meals'][index];
                    return ListTile(
                      title: Text(meal['title']),
                      subtitle: Text('Ready in ${meal['readyInMinutes']} minutes'),
                      trailing: Text(
                        'Calories: ${mealPlan!['nutrients']['calories'].toStringAsFixed(0)}',
                      ),
                    );
                  },
                ),
              ],

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension for capitalizing text
extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
