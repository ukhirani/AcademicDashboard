import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultySubjectDetailsPage extends StatefulWidget {
  final String subjectId;

  const FacultySubjectDetailsPage({required this.subjectId});

  @override
  _FacultySubjectDetailsPageState createState() =>
      _FacultySubjectDetailsPageState();
}

class _FacultySubjectDetailsPageState extends State<FacultySubjectDetailsPage> {
  late Map<String, dynamic> subjectData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjectData();
  }

  _loadSubjectData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .doc(widget.subjectId)
          .get();

      if (snapshot.exists) {
        setState(() {
          subjectData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  _updateField(String field, dynamic value) {
    FirebaseFirestore.instance
        .collection('subjects')
        .doc(widget.subjectId)
        .update({field: value});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Subject Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Subject Name: ${subjectData['subject_name'] ?? 'N/A'}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('Semester: ${subjectData['semester'] ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
                'Course Objectives: ${subjectData['course_objectives'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),

            // Toggle for boolean fields
            SwitchListTile(
              title: Text("Add-on Program Details"),
              value: subjectData['add_on_program_details'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  subjectData['add_on_program_details'] = value;
                });
                _updateField('add_on_program_details', value);
              },
            ),
            SwitchListTile(
              title: Text("Assignment Practical Evaluation"),
              value: subjectData['assignment_practical_eval'] ?? false,
              onChanged: (bool value) {
                setState(() {
                  subjectData['assignment_practical_eval'] = value;
                });
                _updateField('assignment_practical_eval', value);
              },
            ),
            SwitchListTile(
              title: Text("Attendance Report Available"),
              value: subjectData['attendance_report'] != null,
              onChanged: (bool value) {
                setState(() {
                  subjectData['attendance_report'] =
                      value ? 'Report Available' : null;
                });
                _updateField(
                    'attendance_report', value ? 'Report Available' : null);
              },
            ),
            SizedBox(height: 16),

            // Text input for string fields
            TextField(
              controller: TextEditingController(
                  text: subjectData['program_educational_objectives']),
              decoration:
                  InputDecoration(labelText: 'Program Educational Objectives'),
              onChanged: (value) {
                _updateField('program_educational_objectives', value);
              },
            ),
            TextField(
              controller:
                  TextEditingController(text: subjectData['course_objectives']),
              decoration: InputDecoration(labelText: 'Course Objectives'),
              onChanged: (value) {
                _updateField('course_objectives', value);
              },
            ),
            TextField(
              controller:
                  TextEditingController(text: subjectData['course_outcomes']),
              decoration: InputDecoration(labelText: 'Course Outcomes'),
              onChanged: (value) {
                _updateField('course_outcomes', value);
              },
            ),
            SizedBox(height: 16),

            // Dropdown for predefined options
            DropdownButtonFormField<String>(
              value: subjectData['lecture_notes_status'] ?? 'Not Available',
              items: ['Available', 'Partially Available', 'Not Available']
                  .map((String status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  subjectData['lecture_notes_status'] = newValue!;
                });
                _updateField('lecture_notes_status', newValue);
              },
              decoration: InputDecoration(labelText: 'Lecture Notes Status'),
            ),
            SizedBox(height: 16),

            // Date Field
            TextField(
              controller: TextEditingController(
                  text: subjectData['add_on_programs_due_date']),
              decoration: InputDecoration(labelText: 'Add-on Program Due Date'),
              onChanged: (value) {
                _updateField('add_on_programs_due_date', value);
              },
            ),
            SizedBox(height: 16),

            // GridView for Range-based Fields (Example: experiments)
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 20, // Example range 1-20
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text('Experiment ${index + 1}'),
                  value: subjectData['experiment_list_basic']
                          ?.contains(index + 1) ??
                      false,
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        subjectData['experiment_list_basic']?.add(index + 1);
                      } else {
                        subjectData['experiment_list_basic']?.remove(index + 1);
                      }
                    });
                    _updateField('experiment_list_basic',
                        subjectData['experiment_list_basic']);
                  },
                );
              },
            ),
            SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Final save action if necessary, or additional fields to update
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Data updated successfully")));
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
