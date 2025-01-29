import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:biolensproto/screens/home.dart'; // Import the HomePage

class AnalysisPage extends StatelessWidget {
  final List<double> weeklyCalories = [1800, 2200, 2000, 2500, 2300, 2100, 1900]; // Example data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Calorie Intake'),
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
            );
          },
        ),
      ),
      body: Container(
        color: Colors.blue[50], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: weeklyCalories.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          color: Colors.blue[700],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide right Y-axis labels
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide top numbers
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(days[value.toInt()], style: TextStyle(color: Colors.black)),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false), // Removed the border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
