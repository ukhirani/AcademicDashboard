import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectDetailsPage extends StatelessWidget {
  final String subjectId;

  SubjectDetailsPage({required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('subjects')
            .doc(subjectId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          }

          var subject = snapshot.data!;

          // List of fields to display
          List<Map<String, dynamic>> fields = [
            {'label': 'Subject Name', 'value': subject['subject_name']},
            {'label': 'Semester', 'value': subject['semester']},
            {'label': 'Program Type', 'value': subject['degree_diploma']},
            {'label': 'Academic Year', 'value': subject['academic_year']},
            {'label': 'Class', 'value': subject['class']},
            {
              'label': 'Assigned Faculties',
              'value': subject['faculty_list']?.join(', ') ?? 'Not Provided'
            },
            {
              'label': 'Assignments Status',
              'value': subject['assignments_status'] ?? 'Not Provided'
            },
            {
              'label': 'Attendance Report',
              'value': subject['attendance_report'] ?? 'Not Provided'
            },
            {
              'label': 'Course Objectives',
              'value': subject['course_objectives'] ?? 'Field not found'
            },
            {
              'label': 'Lab Plan',
              'value': subject['lab_plan'] ?? 'Not Provided'
            },
            {
              'label': 'Course Overview 1',
              'value': subject['course_overview_1'] ?? 'Not Provided'
            },
            {
              'label': 'Program Educational Objectives',
              'value':
                  subject['program_educational_objectives'] ?? 'Not Provided'
            },
            {
              'label': 'Program Outcomes',
              'value': subject['program_outcomes'] ?? 'Not Provided'
            },
            {
              'label': 'Program Specific Outcomes',
              'value': subject['program_specific_outcomes'] ?? 'Not Provided'
            },
            {
              'label': 'Course PO Matrix Justification',
              'value':
                  subject['course_po_matrix_justification'] ?? 'Not Provided'
            },
            {
              'label': 'Lab Plan Review 1',
              'value': subject['lab_plan_review_1'] ?? 'Not Provided'
            },
            {
              'label': 'Lesson Plan',
              'value': subject['lesson_plan'] ?? 'Not Provided'
            },
            {
              'label': 'Lesson Plan Review 1',
              'value': subject['lesson_plan_review_1'] ?? 'Not Provided'
            },
            {
              'label': 'Self Learning References',
              'value': subject['self_learning_references'] ?? 'Not Provided'
            },
            {
              'label': 'Assignments Status',
              'value': subject['assignments_status'] ?? 'Not Provided'
            },
            {
              'label': 'Gaps Topics Beyond Syllabus',
              'value': subject['gaps_topics_beyond_syllabus'] ?? 'Not Provided'
            },
            {
              'label': 'Continuous Eval Marks',
              'value': subject['continuous_eval_marks'] ?? 'Not Provided'
            },
            {
              'label': 'Question Bank Status',
              'value': subject['question_bank_status'] ?? 'Not Provided'
            },
            {
              'label': 'References Beyond Syllabus',
              'value': subject['references_beyond_syllabus'] ?? 'Not Provided'
            },
            {
              'label': 'Result Analysis Corrective Action',
              'value':
                  subject['result_analysis_corrective_action'] ?? 'Not Provided'
            },
            {
              'label': 'CQI Suggestions',
              'value': subject['cqi_suggestions'] ?? 'Not Provided'
            },
            {
              'label': 'Review 1 Due Date',
              'value': subject['review1_due_date'] ?? 'Not Provided'
            },
            {
              'label': 'Review 2 Due Date',
              'value': subject['review2_due_date'] ?? 'Not Provided'
            },
            {
              'label': 'Review 3 Due Date',
              'value': subject['review3_due_date'] ?? 'Not Provided'
            },
            {
              'label': 'Review 1 Status',
              'value': subject['review_1_status'] ?? 'Not Provided'
            },
            {
              'label': 'Institute VM Status',
              'value': subject['institute_vm_status'] ?? 'Not Provided'
            },
            {
              'label': 'Add-On Program Details',
              'value': subject['add_on_program_details'] ?? 'Not Provided'
            },
            {
              'label': 'Add-On Program Due Date',
              'value': subject['add_on_programs_due_date'] ?? 'Not Provided'
            },
            {
              'label': 'Faculty Time Table',
              'value': subject['faculty_time_table'] ?? 'Not Provided'
            },
            {
              'label': 'Class Time Table',
              'value': subject['class_time_table'] ?? 'Not Provided'
            },
            {
              'label': 'Student Attendance Lab',
              'value': subject['student_attendance_lab'] ?? 'Not Provided'
            },
            {
              'label': 'Student Attendance Theory',
              'value': subject['student_attendance_theory'] ?? 'Not Provided'
            },
            {
              'label': 'Student List',
              'value': subject['student_list'] ?? 'Not Provided'
            },
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                var field = fields[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${field['label']}:',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(
                          child: Text('${field['value']}',
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
