// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:happy_trails/login_page.dart';
import 'main.dart';
import 'package:amplify_api/amplify_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
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
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];

  Future<void> _signUp() async {
    if (_passwordController.text != _passwordControllerChecker.text) {
      //passwords do not match, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: _usernameController.text,
        
      };

      final result = await Amplify.Auth.signUp(
        username: _usernameController.text,
        password: _passwordController.text,
        options: SignUpOptions(userAttributes: userAttributes),
      );

      if (result.isSignUpComplete) {
        //sign-up successful, navigate to the home page or show a success message
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), //navigate to home page
        );
      } else {
        
      }
    } catch (e) {
      //give error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing up.')),
      );
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//pre-amplify code
/*void _signUp() {
    if (_passwordController.text != _passwordControllerChecker.text) {
      // Passwords do not match, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Bypass Amplify signup and navigate to the HomePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Let\'s get to know you',
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
                            controller: _passwordControllerChecker,
                            obscureText: true,
                            style: const TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
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
                          DropdownButtonFormField<String>(
                            style: const TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                              labelText: 'Select State',
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
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
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 64.0),
                          TextButton(
                            onPressed: _signUp,
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
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