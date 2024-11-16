import 'package:flutter/material.dart';

class CCPage extends StatefulWidget {
  final List<String> roles;
  final Function(String) onRoleSwitch;

  CCPage({required this.roles, required this.onRoleSwitch});

  @override
  _CCPageState createState() => _CCPageState();
}

class _CCPageState extends State<CCPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CC'),
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
      body: Center(child: Text('CC Page')),
    );
  }
}
