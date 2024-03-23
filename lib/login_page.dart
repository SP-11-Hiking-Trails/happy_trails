import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'signup_page.dart';

//TODO add animations for smoother transitions between pages
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class LoginPageCont extends StatelessWidget {
  const LoginPageCont({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Trails App',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 5, 66, 7),
      ),
      home: const LoginPageCont(),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                color: Colors.transparent,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 150, 16, 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your guide to \nthe outdoors.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.0,
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
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 20.0),
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
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 20.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                
                                child: ElevatedButton(
                                  onPressed: () {
                                    //login button action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 5, 66, 7),
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 64.0),
                                  ),
                                  child: const Text('Login In'),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              TextButton(
                            onPressed: () {
                              //signup button action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 5, 66, 7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 64.0),
                            ),
                            child: const Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              //signup button action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              backgroundColor: Colors.black.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style:
                                  TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          OutlinedButton(
                            onPressed: () {
                              //continue as guest button action
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              backgroundColor: Colors.black.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 64.0),
                            ),
                            child: const Text(
                              'Continue as Guest',
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