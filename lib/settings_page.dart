import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(String?) updateStateCode;

  const SettingsPage({Key? key, required this.updateStateCode}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedState = "CA";
  //double _textSize = 16.0;

  final List<String> _states = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];

  @override
  void initState() {
    super.initState();
    _selectedState = _states.first;
  }

  void _setLocation(String? state) {
    if (state != null) {
      setState(() {
        _selectedState = state;
      });
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String currentPassword = '';
        String newPassword = '';
        String confirmPassword = '';

        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Change Password', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    currentPassword = value;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    newPassword = value;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    confirmPassword = value;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform password change logic here
                if (newPassword == confirmPassword) {
                  Navigator.of(context).pop();
                } else {
                  // Show an error message if passwords don't match
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[850],
                        title: const Text('Error', style: TextStyle(color: Colors.white)),
                        content: const Text('Passwords do not match.', style: TextStyle(color: Colors.white)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    widget.updateStateCode(_selectedState);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 66, 7),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 66, 7),
                ),
                child: const Text('Change Password'),
              ),
              const SizedBox(height: 32),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedState,
                onChanged: _setLocation,
                items: _states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(
                      state,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 5, 66, 7),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}