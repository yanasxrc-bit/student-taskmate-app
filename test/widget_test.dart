import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_taskmate_app/main.dart';
import 'package:student_taskmate_app/models/task_item.dart';

void main() {
  test('task items compare by value and support copyWith', () {
    final dueDate = DateTime(2026, 1, 10, 9, 30);
    final taskA = TaskItem(
      title: 'Essay draft',
      subject: 'Literature',
      dueDate: dueDate,
      isCompleted: false,
    );
    final taskB = TaskItem(
      title: 'Essay draft',
      subject: 'Literature',
      dueDate: dueDate,
      isCompleted: false,
    );

    expect(taskA, equals(taskB));
    expect(taskA.hashCode, equals(taskB.hashCode));
    expect([taskA].contains(taskB), isTrue);
    expect(taskA.copyWith(isCompleted: true).isCompleted, isTrue);
  });

  testWidgets('home dashboard shows summaries and the navigation bar', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentTaskMateApp());

    expect(find.text('Hi, Alex 🌸'), findsOneWidget);
    expect(find.text('Your overview'), findsOneWidget);
    expect(find.text('Total tasks'), findsOneWidget);
    expect(find.text('Upcoming assignments'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('bottom navigation opens the selected section', (tester) async {
    await tester.pumpWidget(const StudentTaskMateApp());

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Class schedule'), findsOneWidget);
    expect(find.text('Introduction to Psychology'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Completed tasks'), findsOneWidget);
    expect(find.text('Group presentation slides'), findsOneWidget);
  });

  testWidgets('adding a task updates the upcoming assignment list', (
    tester,
  ) async {
    await tester.pumpWidget(const StudentTaskMateApp());

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('task-title-input')),
      'Essay draft',
    );
    await tester.enterText(
      find.byKey(const ValueKey('task-subject-input')),
      'Literature',
    );
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();

    expect(find.text('Essay draft'), findsOneWidget);
    expect(find.text('Literature'), findsOneWidget);
  });
}
