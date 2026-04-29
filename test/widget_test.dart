import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intelligent_admissions/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IntelligentAdmissionsApp());
    expect(find.text('INTELLIGENT'), findsOneWidget);
    expect(find.text('ADMISSION ASSISTANT'), findsOneWidget);
  });
}
