import 'package:flutter/material.dart';

class DegreeProgram {
  final String code;
  final String name;
  final String category;
  final Color bgColor;
  final String shift; // "Morning", "Evening", "Both"
  final int firstSemesterFee;
  final int subsequentFee;
  final int semesters;
  final String scopeDescription;
  final List<String> eligibleDisciplines;

  const DegreeProgram({
    required this.code,
    required this.name,
    required this.category,
    required this.bgColor,
    required this.shift,
    required this.firstSemesterFee,
    required this.subsequentFee,
    required this.semesters,
    required this.scopeDescription,
    required this.eligibleDisciplines,
  });
}
