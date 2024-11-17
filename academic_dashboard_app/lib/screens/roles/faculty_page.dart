import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faculty_subject_details.dart';

class FacultyPage extends StatelessWidget {
  final String facultyName;

  const FacultyPage({required this.facultyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Page'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('subjects').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No subjects found for this faculty.'));
          }

          var subjects = snapshot.data!.docs;
          var filteredSubjects = subjects.where((subject) {
            var facultyList = subject['faculty_list'] != null
                ? List<String>.from(subject['faculty_list'])
                : [];
            return facultyList.contains(facultyName);
          }).toList();

          if (filteredSubjects.isEmpty) {
            return Center(child: Text('No subjects found for this faculty.'));
          }

          return ListView.builder(
            itemCount: filteredSubjects.length,
            itemBuilder: (context, index) {
              var subject = filteredSubjects[index];
              var subjectId = subject.id;
              var subjectName = subject['subject_name'] ?? 'No name provided';
              var semester = subject['semester'] ?? 'No semester specified';

              return ListTile(
                title: Text(subjectName),
                subtitle: Text('Semester: $semester'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Navigate to the SubjectDetailsPage with the subjectId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FacultySubjectDetailsPage(facultyName: facultyName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
