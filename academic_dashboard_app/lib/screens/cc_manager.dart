import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CcManager extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  void addCc(BuildContext context) async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final department = departmentController.text.trim();
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    if (email.isEmpty || name.isEmpty || department.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required.')),
      );
      return;
    }

    try {
      // Check if the CC already exists and update or create
      await FirebaseFirestore.instance.collection('cCs').doc(currentUid).set({
        'email': email,
        'name': name,
        'department': department,
        'role': 'cCs',
        'uid': currentUid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class Coordinator added successfully!')),
      );

      emailController.clear();
      nameController.clear();
      departmentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Class Coordinator: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: departmentController,
            decoration: InputDecoration(labelText: 'Department'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => addCc(context),
            child: Text('Add Class Coordinator'),
          ),
        ],
      ),
    );
  }
}
