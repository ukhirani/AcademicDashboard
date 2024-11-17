import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  final List<String> roles;

  AdminPage({required this.roles});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? selectedRole;

  final List<String> rolesList = [
    'Head Of Department',
    'Class Coordinator',
    'Faculty',
    'Authorities',
    'Admin'
  ];

  void _addOrUpdateUserRoles() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final newRole = selectedRole;

    if (email.isEmpty || name.isEmpty || newRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required.')),
      );
      return;
    }

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user_collection')
          .where('mail', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        String uid = userDoc['UID'];
        List<dynamic> roles = userDoc['roles'];

        if (roles.contains(newRole)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User already has the $newRole role.')),
          );
        } else {
          roles.add(newRole);
          await FirebaseFirestore.instance
              .collection('user_collection')
              .doc(userDoc.id)
              .update({'roles': roles});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role $newRole added successfully!')),
          );
        }
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email, password: "defaultPassword123");
        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('user_collection')
            .doc(uid)
            .set({
          'UID': uid,
          'mail': email,
          'roles': [newRole],
          'userName': name,
        });

        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'New user created and role $newRole assigned! Password reset email sent.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add/update user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: rolesList.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Role',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addOrUpdateUserRoles,
              child: Text('Add/Update Role'),
            ),
          ],
        ),
      ),
    );
  }
}
