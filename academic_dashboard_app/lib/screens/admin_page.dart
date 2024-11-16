import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? selectedRole;
  final roles = ['hODs', 'cCs', 'faculty', 'authorities'];

  void navigateToRolePage(String role) {
    // Navigate to role-specific pages based on the selected role
    Navigator.pushNamed(context, '/${role}ManagerPage');
  }

  Widget buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedRole,
      items: roles.map((role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedRole = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Role to Manage',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildNavigationButton() {
    return ElevatedButton(
      onPressed: selectedRole == null
          ? null
          : () {
              navigateToRolePage(selectedRole!);
            },
      child: Text('Go to $selectedRole Manager'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Admin Panel',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            buildRoleDropdown(),
            const SizedBox(height: 16),
            buildNavigationButton(),
            const SizedBox(height: 24),
            Divider(thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: roles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Manage ${roles[index]}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      navigateToRolePage(roles[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
