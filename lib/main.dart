import 'package:biolensproto/screens/details.dart';
import 'package:biolensproto/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screens/splash_screen.dart';
import '../services/local_notification_service.dart'; // Import notification service
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ruvaidremhiiihkftdnl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ1dmFpZHJlbWhpaWloa2Z0ZG5sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc2ODkxOTYsImV4cCI6MjA0MzI2NTE5Nn0.hbNkBL1yYMF0w4tkscOPoZTq11Qb1TDsFVTG471EAJA');

  // Initialize local notifications
  await LocalNotificationService().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MealPlannerScreen(), // Splash screen is the first screen
    );
  }
}
