import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(String?) updateStateCode;

  const SettingsPage({Key? key, required this.updateStateCode}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  String _selectedState = 'CA';
  //double _textSize = 16.0;

  final List<String> _states = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];

  void _changePassword() {
    // TODO: Implement password change functionality
  }

  void _setLocation(String? state) {
    if (state != null) {
      setState(() {
      _selectedState = state;
    });
    widget.updateStateCode(state);
    }
  }

  // void _setTextSize(double textSize) {
  //   setState(() {
  //     _textSize = textSize;
  //   });
  //   // TODO: Implement text size setting functionality
  // }

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
              // const SizedBox(height: 32),
              // const Text(
              //   'Text Size',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 16),
              // Slider(
              //   value: _textSize,
              //   min: 12,
              //   max: 24,
              //   divisions: 4,
              //   onChanged: _setTextSize,
              //   activeColor: const Color.fromARGB(255, 5, 66, 7),
              //   inactiveColor: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
