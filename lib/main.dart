import 'package:flutter/material.dart';
import 'Trail.dart';
import 'login_page.dart';
import 'signup_page.dart';

//The following trail objects are just some test trails made to populate the home page with something.
//Eventually, the home page will be populated by data from the various trail databases, rather than manually.
Trail trail01 = Trail(
  "Pine Log Creek Trail",
  "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FpCLgzeNLaJY%2Fmaxresdefault.jpg&f=1&nofb=1&ipt=cb19db6b4bcec8175a56e54bed5875d4d2cd936242ca92381c35fb0de2a95ea8&ipo=images",
  "4031 GA-140, Rydal, GA 30171",
  "Moderate",
  4.1,
  4.5,
);

Trail trail02 = Trail(
  "Kennesaw Mountain Summit Trail",
  "https://www.atlantamagazine.com/wp-content/uploads/sites/4/2017/10/KennesawMountain1_courtesy.jpg",
  "900 Kennesaw Mountain Dr, Kennesaw, GA 30152",
  "Easy",
  2.9,
  4.0,
);

Trail trail03 = Trail(
  "Tobacco Pouch Trail",
  "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.0WB08TS8EywfvcEZ-3J8hgHaJ3%26pid%3DApi&f=1&ipt=c2db752fab49381512bd922415b27912d4e8ced5aea85223df7a6e3fe1fe3e89&ipo=images",
  "4293-4525 Monument Rd, Jasper, GA 30143",
  "Difficult",
  4.4,
  5.0,
);

//This list stores all of the created trail objects.
List<Trail> trails = [trail01, trail02, trail03];

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
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: const Text('Happy Trails', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
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
                  Container(
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.all(10),
                    height: 350,
                    width: 350,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(),
                    child: Image.network(trails[index].imageURL,
                        height: 300, width: 300, fit: BoxFit.cover),
                  ),

                  //Container that lists the trail information as a column.
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: <Widget>[
                        //Container for the trail name.
                        Container(
                          alignment: Alignment.center,
                          child: Text(trails[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                              textAlign: TextAlign.left),
                        ),
                        //Container for the trail location.
                        Container(
                          alignment: Alignment.center,
                          child: Text(trails[index].location,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left),
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
                              Container(
                                alignment: Alignment.center,
                                child:
                                    Text(trails[index].trailRating.toString(),
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 25,
                                        ),
                                        textAlign: TextAlign.left),
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
                                child: Text(
                                    "Difficulty: ${trails[index].trailDifficulty}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ),
                              //Container for the trail length.
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                    "Trail Length: ${trails[index].trailLength.toString()} miles.",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

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