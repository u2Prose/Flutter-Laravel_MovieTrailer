// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:flutterapp/Screens/login_screen.dart';
import 'package:flutterapp/Screens/movie_list_screen.dart';
import 'package:flutterapp/Screens/play_movie_screen.dart'; // Import the login screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default to Action Movie screen

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showConfirmationAndPerformAction(
      BuildContext context, String action, VoidCallback onConfirm) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      onConfirm();
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Trailer Dashboard'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image2.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movie Trailer List'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0); // Assuming 0 is the index for Action Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Play Movie Trailers'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0); // Assuming 0 is the index for Action Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayMovieScreen()),
                );
              },
            ),
            // Add other actions here (add, update, delete) if needed, e.g.:
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _showConfirmationAndPerformAction(context, 'logout', _logout);
              },
            ),
          ],
        ),
      ),
    );
  }
}
