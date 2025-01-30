import 'dart:io';

import 'package:biolensproto/screens/profile_page.dart';
import 'package:biolensproto/screens/saved_images.dart';
import 'package:biolensproto/screens/sms_reader.dart';
import 'package:flutter/material.dart';
import 'package:biolensproto/screens/day_goal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'analysis.dart';
import 'log.dart';

class HomePage extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top section with clouds and profile information
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    // Back button and Home text
                    Positioned(
                      top: 9,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 40,
                      child: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Clouds or decorations in the background
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Icon(Icons.cloud, size: 40, color: Colors.white),
                    ),
                    Positioned(
                      top: 60,
                      left: 30,
                      child: Icon(Icons.cloud, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      top: 100,
                      right: 50,
                      child: Icon(Icons.cloud, size: 50, color: Colors.white),
                    ),
                    // Profile Picture and Greeting
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                                'assets/images/profile.png'),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Hi, User',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'mail',
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Circular Buttons (3 on the first row, 2 on the second)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    circularButton(
                      'Today\'s Goal',
                      Icons.mood,
                      Colors.green[100]!,
                          () {(
                          id: 0,
                          title: 'Today\'s Goal',
                          body: 'You are making great progress towards your goal!',
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalPage(Goal: 550),
                          ),
                        );
                      },
                    ),
                    circularButton(
                      'Analysis',
                      Icons.assessment,
                      Colors.orange[100]!,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnalysisPage()),
                        );
                      },
                    ),
                    circularButton(
                        'SMS Reader',
                        Icons.chat_bubble_outline,
                        Colors.yellow[100]!,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EBillReaderPage()), // Navigate to Log Page
                          );
                        }
                    ),
                    circularButton(
                      'Groceries',
                      Icons.shopping_bag_outlined,
                      Colors.purple[100]!,
                      null,
                    ),
                    circularButton(
                      'Log',
                      Icons.list_alt,
                      Colors.blue[100]!,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NutritionLogPage()), // Navigate to Log Page
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Saved Images',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == 1) {
              openCamera(context);
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedImagesPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }
          },
        ),
      ),
    );
  }

  // Function to create circular button widgets with an action
  Widget circularButton(
      String label, IconData icon, Color color, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Function to open the camera
  Future<void> openCamera(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String appPath = appDirectory.path;
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File savedImage = File('$appPath/$fileName.png');

      await File(photo.path).copy(savedImage.path);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Image Saved'),
          content: Text('The image has been saved to app storage at $appPath/$fileName.png.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }
}
