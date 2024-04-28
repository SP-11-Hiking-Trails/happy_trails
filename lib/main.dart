//amplify api packages ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:math';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:happy_trails/settings_page.dart';
import 'amplifyconfiguration.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:happy_trails/amplifyconfiguration.dart';
// ignore: depend_on_referenced_packages
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';



//dart packages ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
// import 'trail.dart';
import 'login_page.dart';
import 'settings_page.dart';
import 'package:happy_trails/Trail.dart';
//import 'signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:happy_trails/trail_review.dart';



Future<void>_configureAmplify() async {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    final analytics = AmplifyAnalyticsPinpoint();
    try {
      
      await Amplify.addPlugins([auth,storage,analytics]);

      await Amplify.configure(amplifyconfig);

    } on Exception catch(e) {
      safePrint(e);
    }
}
Future<void> submitReview(String trailId, int rating) async {
  try {
    final reviewId = UUID().toString();
    final review = TrailReview(
      id: reviewId,
      trailId: trailId,
      rating: rating,
    );

    await Amplify.DataStore.save(review);
    print('Review submitted successfully');
  } catch (e) {
    print('Error submitting review: $e');
  }
}
Future<void> fetchTrailRating(String trailId) async {
  try {
    final reviews = await Amplify.DataStore.query(
      TrailReview.classType,
      where: const QueryField(fieldName: 'trailId').eq(trailId),
    );

    if (reviews.isNotEmpty) {
      final totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
      final avgRating = totalRating / reviews.length;
      final numRatings = reviews.length;

      // Fetch the trail details from the DataStore using the trail ID
      final trail = await Amplify.DataStore.query(
        Trail.classType,
        where: const QueryField(fieldName: 'id').eq(trailId),
      );

      if (trail.isNotEmpty) {
        // Update the trail's average rating and number of ratings
        final updatedTrail = trail.first.copyWith(
          avgRating: avgRating,
          numRatings: numRatings,
        );

        // Save the updated trail object to the DataStore
        await Amplify.DataStore.save(updatedTrail);
      }
    }
  } catch (e) {
    print('Error fetching trail rating: $e');
  }
}
class TrailReview extends Model {
  static const String TRAIL_ID = "trailId";

  final String id;
  final String trailId;
  final int rating;

  TrailReview({
    required this.id,
    required this.trailId,
    required this.rating,
  });

  @override
  String getId() {
    return id;
  }

  static const classType = const _TrailReviewModelType();

  @override
  getInstanceType() => classType;

  Map<String, dynamic> serializeAsMap() {
    return {
      'id': id,
      'trailId': trailId,
      'rating': rating,
    };
  }

  factory TrailReview.fromJson(Map<String, dynamic> json) {
    return TrailReview(
      id: json['id'],
      trailId: json['trailId'],
      rating: json['rating'],
    );
  }
}

class _TrailReviewModelType extends ModelType<TrailReview> {
  const _TrailReviewModelType();

  @override
  TrailReview fromJson(Map<String, dynamic> jsonData) {
    return TrailReview.fromJson(jsonData);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await _configureAmplify();
  runApp(const MyApp());
}


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
// ignore: must_be_immutable
class TrailDetailScreen extends StatefulWidget {
  Trail trail;

  TrailDetailScreen({Key? key, required this.trail}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrailDetailScreenState createState() => _TrailDetailScreenState();
}

class _TrailDetailScreenState extends State<TrailDetailScreen> {
  int _userRating = 0;

  void _submitRating() {
    if (_userRating > 0) {
      final newRating = _userRating.toDouble();
      final currentRating = widget.trail.avgRating;
      final currentUserCount = widget.trail.numRatings;

      final newAvgRating = (currentRating * currentUserCount + newRating) / (currentUserCount + 1);
      final newUserCount = currentUserCount + 1;

      final updatedTrail = widget.trail.copyWith(
        avgRating: newAvgRating,
        numRatings: newUserCount,
      );

      setState(() {
        widget.trail = updatedTrail;
      });
      

      submitReview(widget.trail.id, _userRating);
      fetchTrailRating(widget.trail.id);

      _updateTrailInHomePage(updatedTrail); 
      }
}
void _updateTrailInHomePage(Trail updatedTrail) {
  final homePageState = context.findAncestorStateOfType<_HomePageState>();
  if (homePageState != null) {
    homePageState._updateTrail(updatedTrail);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: Text(widget.trail.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.trail.imageURLs.isNotEmpty)
              Image.network(
                widget.trail.imageURLs[0],
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
                    widget.trail.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.trail.location,
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
                        widget.trail.avgRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rated by ${widget.trail.numRatings} users',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.trail.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rate this trail:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        IconButton(
                          icon: Icon(
                            Icons.star,
                            color: i <= _userRating ? Colors.amber : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _userRating = i;
                            });
                           
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 5, 66, 7),
                    ),
                    child: const Text('Submit Rating'),
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

    List<Trail> updatedTrails = [];

    for (final trailData in trailsData) {
      final trail = Trail.fromJson(trailData);
      await fetchTrailRating(trail.id);
      updatedTrails.add(trail);
    }

    setState(() {
      _trails = updatedTrails;
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
  String _selectedState ='GA';



void _updateStateCode(String? stateCode) { //gets called from settings_page to change state location
  if (stateCode != null) {
    setState(() {
      _selectedState = stateCode;
    });
    _fetchTrails();
  }
}

  @override
  void initState() {
    super.initState();
    _fetchTrails();
  }

  Future<void> _fetchTrails() async {
    const String apiKey = "yILxmZnKvTAHCrtoQFkazmFhQ6ufbvhIfrD69R8P";
    String stateCode = _selectedState;
    String url = 'https://developer.nps.gov/api/v1/parks?stateCode=$stateCode&limit=50&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> trailsData = jsonData['data'];
      final random = Random();

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

  //get trails => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = (index == 1);
    });

    if (index == 2) {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          updateStateCode: _updateStateCode,
      ))
      );
    }
  }


  void _performSearch(String q) {
  setState(() {
    _searchQuery = q;
    _searchResults = _trails
        .where((trail) =>
            trail.name.toLowerCase().contains(q.toLowerCase()) ||
            trail.location.toLowerCase().contains(q.toLowerCase()))
        .map((trail) {
          final matchingTrail = _trails.firstWhere((t) => t.id == trail.id);
          return trail.copyWith(
            avgRating: matchingTrail.avgRating,
            numRatings: matchingTrail.numRatings,
          );
        })
        .toList();
  });
}
void _updateTrail(Trail updatedTrail) {
  setState(() {
    final index = _trails.indexWhere((trail) => trail.id == updatedTrail.id);
    if (index != -1) {
      _trails[index] = updatedTrail;
    }
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
                          ).then((updatedTrail) {
                              if (updatedTrail != null && updatedTrail is Trail) {
                                _updateTrail(updatedTrail);
                              }
                            });
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
                                  fontSize: 32,
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
                                    trail.avgRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 5), // Add some spacing between the rating and the additional text
                                  Text(
                                    "rated by ${trail.numRatings.toInt()} users",
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
                                    //     "Difficulty: ${trail.trailDifficulty}", //removed for now, NPS api doesnt provide this information
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
