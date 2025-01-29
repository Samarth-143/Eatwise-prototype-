import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:biolensproto/screens/home.dart'; // Import HomePage
import 'package:biolensproto/screens/profile_page.dart'; // Import ProfilePage

class SavedImagesPage extends StatefulWidget {
  @override
  _SavedImagesPageState createState() => _SavedImagesPageState();
}

class _SavedImagesPageState extends State<SavedImagesPage> {
  List<FileSystemEntity> _savedImages = [];
  int _selectedIndex = 2; // Set the initial index for Saved Images

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String appPath = appDirectory.path;

    // List all files in the app's directory
    final Directory directory = Directory(appPath);
    final List<FileSystemEntity> images = directory.listSync();

    setState(() {
      _savedImages = images.where((image) => image.path.endsWith('.png')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Images'),
      ),
      body: _savedImages.isEmpty
          ? Center(child: Text('No images saved.'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _savedImages.length,
        itemBuilder: (context, index) {
          final imageFile = _savedImages[index];
          return Image.file(
            File(imageFile.path),
            fit: BoxFit.cover,
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          currentIndex: _selectedIndex, // Set the current index here
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
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (index == 1) {
              // Handle scan logic
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
}
