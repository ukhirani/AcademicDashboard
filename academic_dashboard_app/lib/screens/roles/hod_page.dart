import 'package:flutter/material.dart';

class HODPage extends StatefulWidget {
  final List<String> roles;
  final Function(String) onRoleSwitch;

  const HODPage({required this.roles, required this.onRoleSwitch});

  @override
  _HODPageState createState() => _HODPageState();
}

class _HODPageState extends State<HODPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOD Page'),
      ),
      body: Column(
        children: widget.roles.map((role) {
          return ElevatedButton(
            onPressed: () {
              if (!mounted) return; // Check if mounted before setState
              widget.onRoleSwitch(role);
            },
            child: Text(role),
          );
        }).toList(),
      ),
    );
  }
}
