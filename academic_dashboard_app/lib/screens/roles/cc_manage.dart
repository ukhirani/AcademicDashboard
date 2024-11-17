import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cc_subject_details.dart'; // Import the new SubjectDetailsPage

class CCManagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Subjects'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('subjects')
            .where('cc_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No subjects found.'));
          }

          var subjects = snapshot.data!.docs;

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              var subject = subjects[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['subject_name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Semester: ${subject['semester']}'),
                      Text('Program Type: ${subject['degree_diploma']}'),
                      Text('Academic Year: ${subject['academic_year']}'),
                      Text('Class: ${subject['class']}'),
                      Text(
                          'Assigned Faculties: ${subject['faculty_list'].join(', ')}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the SubjectDetailsPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubjectDetailsPage(subjectId: subject.id),
                            ),
                          );
                        },
                        child: Text('Manage Subject'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
