import 'package:flutter/material.dart';

class RoleSelectionPage extends StatefulWidget {
  final List<String> roles;

  RoleSelectionPage({required this.roles});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: ListView.builder(
        itemCount: widget.roles.length,
        itemBuilder: (context, index) {
          String role = widget.roles[index];
          return ListTile(
            title: Text(role),
            selected: _selectedRole == role,
            onTap: () {
              setState(() {
                _selectedRole = role;
              });
              switch (role) {
                case 'admin':
                  Navigator.pushReplacementNamed(context, '/adminPage');
                  break;
                case 'hODs':
                  Navigator.pushReplacementNamed(context, '/hodPage');
                  break;
                case 'cCs':
                  Navigator.pushReplacementNamed(context, '/ccPage');
                  break;
                case 'faculty':
                  Navigator.pushReplacementNamed(context, '/facultyPage');
                  break;
                case 'authorities':
                  Navigator.pushReplacementNamed(context, '/authorityPage');
                  break;
              }
            },
            selectedTileColor: Colors
                .blue.shade100, // Optional: Add color for the selected role
          );
        },
      ),
    );
  }
}
