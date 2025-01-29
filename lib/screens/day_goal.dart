import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import the percent indicator package
import '../services/local_notification_service.dart'; // Import the notification service

class GoalPage extends StatelessWidget {
  final int Goal; // You can pass the stress level value dynamically

  GoalPage({required this.Goal});

  @override
  Widget build(BuildContext context) {
    // Show notification when the page is built
    _showGoalNotification();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Today\'s Goal',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Add a background circle pattern
          Positioned.fill(
            child: CustomPaint(
              painter: CirclePatternPainter(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // First line with Low and Moderate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('(0-1000) - Low', style: TextStyle(color: Colors.green)),
                    Text('(1001-2000) - Moderate', style: TextStyle(color: Colors.orange)),
                  ],
                ),
                SizedBox(height: 10), // A little space between the two lines

                // Second line with High
                Align(
                  alignment: Alignment.center, // Center align the text
                  child: Text(
                    '(2001-3000) - High',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20), // Space between the range indicators and other content

                // Stress level message and percentage
                Text(
                  'Your Calory intake: $Goal/3000', // Change to show 3000 as the max
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Stress description based on the level
                Text(
                  getGoalDescription(Goal),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),

                // Spacer to push content up
                Spacer(),
              ],
            ),
          ),

          // Add a circle behind the CircularPercentIndicator
          Positioned(
            bottom: 20, // Adjust the positioning as necessary
            right: 20, // Adjust the positioning as necessary
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circle behind the indicator
                Container(
                  width: 150, // Adjust the size as needed
                  height: 150, // Adjust the size as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.2), // Background color for the circle
                  ),
                ),
                // CircularPercentIndicator in the foreground
                CircularPercentIndicator(
                  radius: 100.0, // Adjust the size as needed
                  lineWidth: 8.0,
                  animation: true,
                  percent: Goal / 3000, // Corrected to use 3000 as the base for percentage calculation
                  center: Text(
                    '${((Goal / 3000) * 100).toStringAsFixed(1)}%', // Displaying the Goal percentage out of 3000
                    style: TextStyle(
                      fontSize: 24, // Adjust size if necessary
                      fontWeight: FontWeight.bold,
                      color: getColorForGoalLevel(Goal),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: getColorForGoalLevel(Goal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to show notification
  void _showGoalNotification() {
    String message = getGoalDescription(Goal);
    LocalNotificationService().showNotification(
      id: 0, // Notification ID
      title: 'Goal Achieved!',
      body: 'Your Calory intake: $Goal/3000. $message',
    );
  }

  // Helper function to get stress description
  String getGoalDescription(int level) {
    if (level <= 1000) {
      return 'You are doing great. Keep up the good work!';
    } else if (level <= 2000 || level>1000) {
      return 'I see that you are enjoying your food today. That\'s nice. Let\'s have some more :).';
    } else {
      return 'It looks like you had your fill today. But you better stop now.';
    }
  }

  // Helper function to get the color based on stress level
  Color getColorForGoalLevel(int level) {
    if (level <= 1000) {
      return Colors.green;
    } else if (level <= 2000 || level>1000) {
      return Colors.orange[400]!;
    } else {
      return Colors.red;
    }
  }
}

// Painter for the circle pattern background
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent.withOpacity(0.2);

    // Drawing circles in a pattern
    final circles = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.4, size.height * 0.1),
      Offset(size.width * 0.6, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.15),
      Offset(size.width * 0.3, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.1, size.height * 0.55),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.35),
      Offset(size.width * 1.0, size.height * 0.7),
      Offset(size.width * 1.0, size.height * 0.2),
    ];

    // Draw the circles with varying radii
    for (final circle in circles) {
      canvas.drawCircle(circle, 30, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
