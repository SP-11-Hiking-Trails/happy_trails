import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:happy_trails/login_page.dart';
import 'main.dart';



class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
    @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class SignupPageCont extends StatelessWidget {
  const SignupPageCont({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Trails App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 5, 66, 7),
      ),
      home: const SignupPageCont(),
    );
  }
}


class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordControllerChecker = TextEditingController();
  String? _selectedState;

  final List<String> _states = [

//add state abv 
    'GA',
    'AL',
    'FL',
    'NY',
    //etc

  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/glacier03.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  child: Align(alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     // const SizedBox(height: 0),
                      const Text(
                        'Lets get to know you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 20.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true, //for testing purposes 
                                fillColor: Colors.black.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 20.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: _passwordControllerChecker,
                              obscureText: true,
                              style: const TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true, //for testing purposes 
                                fillColor: Colors.black.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 20.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            //stateselector dropdown menu 
                            const SizedBox(height: 16.0),
                            DropdownButtonFormField<String>(
                              style: const TextStyle(color: Colors.grey),
                              decoration: InputDecoration(
                              labelText: 'Select State',
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true, //for testing purposes 
                              fillColor: Colors.black.withOpacity(0.4),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black, width: 20.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              value: _selectedState,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                });
                              },
                              items: _states.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String> (
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 64.0),
                            TextButton(
                              onPressed: () { //signup button action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage())
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 5, 66, 7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            OutlinedButton(
                              onPressed: () { //continue as guest button action
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage())
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                                backgroundColor: Colors.black.withOpacity(0.4),
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              ),
                              child: const Text(
                                'Go back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
        ],
      ),
    );
  }
}