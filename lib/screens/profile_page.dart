import 'package:flutter/material.dart';
import 'package:biolensproto/screens/home.dart';
import 'package:biolensproto/screens/saved_images.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Set default index for Profile

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevent reloading same page

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SavedImagesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        TextButton(
                          onPressed: () {},
                          child: Text('Edit', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),

            // Badges Section
            ListTile(
              title: Text('Badges'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            Container(
              height: 120,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    BadgeTile(
                      image: Icons.emoji_food_beverage,
                      label: '   ',
                      date: '21 Feb 2024',
                    ),
                    SizedBox(width: 16),
                    BadgeTile(
                      image: Icons.directions_walk,
                      label: '  ',
                      date: '9 Jan 2024',
                    ),
                  ],
                ),
              ),
            ),

            Divider(),

            // Personal Best Section
            ListTile(
              title: Text('Personal Best'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.directions_run, size: 40, color: Colors.orange),
              title: Text(
                '895',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Least Calories'),
            ),
            Divider(),

            // Weekly Summary Section
            ListTile(
              title: Text('Weekly Summary'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('12–18 January'),
                  Text(
                    'Average active time',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Spacer(),
                  Text(
                    '10,000 calories',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Saved Images'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class BadgeTile extends StatelessWidget {
  final IconData image;
  final String label;
  final String date;

  const BadgeTile({
    required this.image,
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[100],
          child: Icon(image, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
