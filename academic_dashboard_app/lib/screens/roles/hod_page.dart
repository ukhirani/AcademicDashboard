import 'package:flutter/material.dart';

class HODPage extends StatelessWidget {
  final List<String> roles;

  const HODPage({required this.roles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOD Page'),
      ),
      body: Center(
        child: Text('Welcome to the HOD Page!'),
      ),
    );
  }
}
