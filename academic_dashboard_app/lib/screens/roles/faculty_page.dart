import 'package:flutter/material.dart';

class FacultyPage extends StatefulWidget {
  final List<String> roles;
  final Function(String) onRoleSwitch;

  FacultyPage({required this.roles, required this.onRoleSwitch});

  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty'),
        actions: [
          DropdownButton<String>(
            value: selectedRole,
            onChanged: (role) {
              if (role != selectedRole) {
                setState(() {
                  selectedRole = role;
                });
                widget.onRoleSwitch(role.toString());
              }
            },
            items: widget.roles.map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            hint: Text('Switch Role', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(child: Text('Faculty Page')),
    );
  }
}
