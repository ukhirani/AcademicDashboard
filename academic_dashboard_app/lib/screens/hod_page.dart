import 'package:flutter/material.dart';

class HodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Head of Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Department Overview', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            // Fetch data from Firestore and display statistics, e.g., subjects, faculty list, etc.
            // Example: ListView to show subjects and faculty details
            Expanded(
                child: ListView.builder(
              itemCount: 10, // Example count of subjects
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Subject ${index + 1}'),
                  subtitle: Text('Faculty assigned'),
                  onTap: () {
                    // Navigate to subject details or faculty info
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
