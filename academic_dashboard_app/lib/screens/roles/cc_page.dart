import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cc_manage.dart';

class CCPage extends StatefulWidget {
  final List<String> roles;

  const CCPage({required this.roles});

  @override
  _CCPageState createState() => _CCPageState();
}

class _CCPageState extends State<CCPage> {
  String? selectedSemester;
  String? selectedProgramType; // Degree or Diploma
  String? selectedAcademicYear;
  String? selectedFaculty;
  String? selectedClass;
  String? selectedSubject;
  List<String> facultyNames = [];
  List<String> classList = [];
  List<String> subjectList = [];

  @override
  void initState() {
    super.initState();
    _fetchFacultyNames();
  }

  void _fetchFacultyNames() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user_collection')
          .where('roles', arrayContains: 'Faculty')
          .get();

      setState(() {
        facultyNames =
            snapshot.docs.map((doc) => doc['userName'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch faculty names: $e')),
      );
    }
  }

  void _updateClassAndSubjectLists() {
    if (selectedSemester != null) {
      int semester = int.parse(selectedSemester!);

      // Update classes based on semester
      setState(() {
        classList = List.generate(2, (index) => '${semester}TK${index + 1}');
      });

      // Update subjects based on semester and program type
      setState(() {
        subjectList = _getSubjectListForSemester(semester, selectedProgramType);
      });
    } else {
      setState(() {
        classList = [];
        subjectList = [];
      });
    }
  }

  List<String> _getSubjectListForSemester(int semester, String? programType) {
    if (programType == 'Degree') {
      switch (semester) {
        case 1:
          return ['Mathematics I', 'Physics I', 'Chemistry'];
        case 2:
          return ['Mathematics II', 'Electrical Engineering'];
        case 3:
          return ['Data Structures', 'Algorithms'];
        // Add more cases for each semester as needed
        default:
          return ['Subject A', 'Subject B']; // Default subjects
      }
    } else if (programType == 'Diploma') {
      switch (semester) {
        case 1:
          return ['Basics of Engineering', 'Applied Physics'];
        case 2:
          return ['Digital Electronics', 'Programming Basics'];
        // Add cases for other semesters as needed
        default:
          return ['Subject X', 'Subject Y']; // Default subjects
      }
    }
    return [];
  }

  Future<void> _createSubject() async {
    final subjectName = selectedSubject;
    final semester = selectedSemester;
    final programType = selectedProgramType;
    final academicYear = selectedAcademicYear;
    final className = selectedClass;

    if (subjectName == null ||
        semester == null ||
        programType == null ||
        academicYear == null ||
        selectedFaculty == null ||
        className == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    // Get the current user's UID
    String? ccId = FirebaseAuth.instance.currentUser?.uid;
    if (ccId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated.')),
      );
      return;
    }

    // Generate a unique subject_id using a hash
    final subjectId = '${semester}_${programType}_$subjectName'.hashCode;

    // Check for duplicates in Firestore
    try {
      QuerySnapshot duplicateCheck = await FirebaseFirestore.instance
          .collection('subjects')
          .where('subject_id', isEqualTo: subjectId)
          .get();

      if (duplicateCheck.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Subject already exists for this combination.')),
        );
        return;
      }

      // Add subject to Firestore with cc_id field and null fields
      await FirebaseFirestore.instance.collection('subjects').add({
        'academic_year': academicYear,
        'degree_diploma': programType,
        'semester': int.parse(semester),
        'subject_name': subjectName,
        'subject_id': subjectId,
        'class': className,
        'faculty_list': [selectedFaculty],
        'cc_id': ccId, // Add the cc_id field
        'add_on_program_details': null,
        'add_on_programs_due_date': null,
        'assignment_practical_eval': null,
        'assignments_status': null,
        'attendance_report': null,
        'class_time_table': null,
        'co_po_matrix_justification': null,
        'continuous_eval_marks': null,
        'course_attainment_sheet': null,
        'course_objectives': null,
        'course_outcomes': null,
        'course_overview_1': null,
        'course_po_matrix_justification': null,
        'course_syllabus_scheme': null,
        'cqi_suggestions': null,
        'daily_delivery_record': null,
        'e_material_status': null,
        'experiment_list_advanced': null,
        'experiment_list_basic': null,
        'faculty_time_table': null,
        'gaps_add_on_plans': null,
        'gaps_topics_beyond_syllabus': null,
        'institute_vm_status': null,
        'internal_paper_key': null,
        'lab_plan': null,
        'lab_plan_review_1': null,
        'lecture_notes_status': null,
        'lesson_plan': null,
        'lesson_plan_review_1': null,
        'po_pso_attainment_sheet': null,
        'program_educational_objectives': null,
        'program_outcomes': null,
        'program_specific_outcomes': null,
        'question_bank_status': null,
        'references_beyond_syllabus': null,
        'result_analysis_corrective_action': null,
        'review1_due_date': null,
        'review2_due_date': null,
        'review3_due_date': null,
        'review_1_status': null,
        'self_learning_references': null,
        'student_attendance_lab': null,
        'student_attendance_theory': null,
        'student_list': null,
        'tutorials_status': null,
        'university_question_papers': null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject created successfully!')),
      );

      // Clear the form
      setState(() {
        selectedSemester = null;
        selectedProgramType = null;
        selectedAcademicYear = null;
        selectedFaculty = null;
        selectedClass = null;
        selectedSubject = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create subject: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Coordinator Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedAcademicYear,
              items: List.generate(5, (index) {
                return DropdownMenuItem(
                  value: (2020 + index).toString(),
                  child: Text('Year ${2020 + index}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedAcademicYear = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Academic Year',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              items: List.generate(8, (index) {
                return DropdownMenuItem(
                  value: (index + 1).toString(),
                  child: Text('Semester ${index + 1}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                  _updateClassAndSubjectLists();
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Semester',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedProgramType,
              items: ['Degree', 'Diploma'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProgramType = value;
                  _updateClassAndSubjectLists();
                });
              },
              decoration: InputDecoration(
                labelText: 'Program Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              items: subjectList.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedClass,
              items: classList.map((classItem) {
                return DropdownMenuItem(
                  value: classItem,
                  child: Text(classItem),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Class',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedFaculty,
              items: facultyNames.map((faculty) {
                return DropdownMenuItem(
                  value: faculty,
                  child: Text(faculty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFaculty = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Faculty',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createSubject,
              child: Text('Create Subject'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CCManagePage()),
                );
              },
              child: Text('Manage Subjects'),
            ),
          ],
        ),
      ),
    );
  }
}
