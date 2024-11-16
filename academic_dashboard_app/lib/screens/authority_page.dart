import 'package:flutter/material.dart';

class AuthorityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Higher Authority Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Overall Status of Departments',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            // Show department statistics, tasks completion statuses
            Expanded(
                child: ListView.builder(
              itemCount: 5, // Example number of departments
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Department ${index + 1}'),
                  subtitle: Text('Tasks: 80% Complete'),
                  onTap: () {
                    // View department overview or individual task statuses
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
