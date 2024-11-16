import 'package:flutter/material.dart';

class CcPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class Coordinator Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Class Coordinator Dashboard', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            // Show subjects, faculty assigned to them, and task completion statuses
            Expanded(
                child: ListView.builder(
              itemCount: 5, // Example count of subjects or faculty members
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Faculty ${index + 1}'),
                  subtitle: Text('Assigned to Subject ${index + 1}'),
                  onTap: () {
                    // Navigate to task details or assign new tasks
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
