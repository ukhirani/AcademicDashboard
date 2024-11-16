import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleManager extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  String? selectedRole;

  final List<String> roles = ['hODs', 'cCs', 'faculty', 'authorities'];

  void addUser(BuildContext context) async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final department = departmentController.text.trim();
    final role = selectedRole;
    final password = "password123";

    if (email.isEmpty || name.isEmpty || role == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('All fields are required.')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection(role).doc(uid).set({
        'email': email,
        'name': name,
        'department': department,
        'role': role,
        'uid': uid,
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$role user added successfully!')));

      emailController.clear();
      nameController.clear();
      departmentController.clear();
      selectedRole = null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add user: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email')),
        TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name')),
        TextField(
            controller: departmentController,
            decoration: InputDecoration(labelText: 'Department (Optional)')),
        DropdownButtonFormField<String>(
          value: selectedRole,
          items: roles
              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
              .toList(),
          onChanged: (value) => selectedRole = value,
          decoration: InputDecoration(labelText: 'Select Role'),
        ),
        ElevatedButton(
            onPressed: () => addUser(context), child: Text('Add User')),
      ],
    );
  }
}
