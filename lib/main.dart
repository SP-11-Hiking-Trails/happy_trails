import 'package:flutter/material.dart';
import 'trail.dart';
import 'login_page.dart';
//import 'signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

//calls the information for a trail/park from the api, routes to a new page with just picture, rating and description
class TrailDetailScreen extends StatelessWidget {

  final Trail trail;

  const TrailDetailScreen({Key? key, required this.trail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: Text(trail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trail.imageURLs.isNotEmpty)
              Image.network(
                trail.imageURLs[0],
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    trail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trail.location,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trail.trailRating.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rated by ${trail.trailUsers.toInt()} users',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    trail.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//handles the search screen 
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Trail> _trails = [];
  String _searchQuery = '';

  Future<void> _fetchTrails() async {
    const String apiKey = "yILxmZnKvTAHCrtoQFkazmFhQ6ufbvhIfrD69R8P";
    final String url = 'https://developer.nps.gov/api/v1/parks?limit=500&q=$_searchQuery&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> trailsData = jsonData['data'];

      setState(() {
        _trails = trailsData.map((json) => Trail.fromJson(json)).toList();
      });
    } else {
      print('Failed to reach trail information. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _fetchTrails();
          },
          decoration: const InputDecoration(
            hintText: 'Search trails...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _trails.length,
        itemBuilder: (BuildContext context, int index) {
          final trail = _trails[index];
          return ListTile(
            title: Text(
              trail.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              trail.location,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrailDetailScreen(trail: trail),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class _HomePageState extends State<HomePage> {
  List<Trail> _trails = [];
  List<Trail> _searchResults = [];
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchTrails();
  }

  Future<void> _fetchTrails() async {
    const String apiKey = "yILxmZnKvTAHCrtoQFkazmFhQ6ufbvhIfrD69R8P";
    const String stateCode = "GA"; //TODO add get statement for statecode
    const String url = 'https://developer.nps.gov/api/v1/parks?stateCode=$stateCode&limit=50&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> trailsData = jsonData['data'];

      setState(() {
        _trails = trailsData
            .map((json) => Trail.fromJson(json))
            .where((trail) {
              final name = trail.name.toLowerCase();
              return name.contains('park') ||
                  name.contains('trail') ||
                  name.contains('mountain') ||
                  name.contains('recreation') ||
                  name.contains('river');
            })
            .toList();
        _trails.sort((a, b) => a.location.compareTo(b.location));
        //_trails.shuffle();  //shuffle for fun :)
      });
    } else {
      // Handle error case
      print('Failed to reach trail information. Status code: ${response.statusCode}');
    }
  }

  int _selectedIndex = 0;

  get trails => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = (index == 1);
    });
  }

  void _performSearch(String q) {
    setState(() {
      _searchQuery = q;
      _searchResults = _trails
          .where((trail) =>
              trail.name.toLowerCase().contains(q.toLowerCase()) ||
              trail.location.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: const Text('Happy Trails', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _isSearching ? _searchResults.length : _trails.length,
            itemBuilder: (BuildContext context, int index) {
              final trail = _isSearching ? _searchResults[index] : _trails[index];
              return Container(
                height: 400,
                width: 600,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: <Widget>[
                    //SizedBox that displays the trail's image.
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrailDetailScreen(trail: trail),
                            ),
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          padding: const EdgeInsets.all(10),
                          height: 350,
                          width: 350,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(),
                          child: trail.imageURLs.isNotEmpty
                              ? Image.network(
                                  trail.imageURLs[0],
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                )
                              : const Icon(Icons.image),
                        ),
                      ),
                    ),
                    //Container that lists the trail information as a column.
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            //Container for the trail name.
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                trail.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            //Container for the trail location.
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                trail.location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            //Container for the trail rating. Created as a row so a star icon can be included.
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.amber,
                                    child: const Icon(Icons.star),
                                  ),
                                  Text(
                                    trail.trailRating.toString(),
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 5), // Add some spacing between the rating and the additional text
                                  Text(
                                    "rated by ${trail.trailUsers.toInt()} users",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            //Container for the trail difficulty and length.
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                children: <Widget>[
                                  //Container for the trail difficulty.
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    // child: Text(
                                    //     "Difficulty: ${trail.trailDifficulty}",
                                    //     style: const TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 18,
                                    //     )),
                                  ),
                                  //Container for the trail length.
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    // child: Text(
                                    //     "Trail Length: ${trail.trailLength.toString()} miles.",
                                    //     style: const TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 18,
                                    //     )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_isSearching)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _performSearch,
                  decoration: const InputDecoration(
                    hintText: 'Search trails...',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
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
