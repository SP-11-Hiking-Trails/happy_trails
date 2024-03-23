import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Trails App',
      initialRoute: '/login', //sets the inital route to the login page
      routes: {
        '/login' :(context) => const LoginPage(),
        '/home' :(context) => const HomePage(),
      }
    
   
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Trails'),
      ),
      body: const Center(
        child: Text('This is the main content area'),
      ),


      //bottom navigation bar, will add profile options, etc
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 5, 66, 7),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Color.fromARGB(255, 5, 66, 7),
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 5, 66, 7),
            activeIcon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}