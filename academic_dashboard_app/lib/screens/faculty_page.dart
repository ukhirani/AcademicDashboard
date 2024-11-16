import 'package:flutter/material.dart';

class FacultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faculty Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Manage Subjects and Tasks', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            // Display a list of subjects and tasks for the faculty
            Expanded(
                child: ListView.builder(
              itemCount: 5, // Example count of subjects or tasks
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Task ${index + 1}'),
                  subtitle: Text('Status: Pending'),
                  onTap: () {
                    // Navigate to task details or mark it as complete
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
