import 'package:flutter/material.dart';

import 'models/task_item.dart';
import 'screens/home_screen.dart';
import 'screens/section_screen.dart';

void main() {
  runApp(const StudentTaskMateApp());
}

class StudentTaskMateApp extends StatelessWidget {
  const StudentTaskMateApp({super.key});

  static const Color pink = Color(0xFFE78FA9);
  static const Color ink = Color(0xFF322A2D);

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: pink,
          brightness: Brightness.light,
        ).copyWith(
          primary: pink,
          secondary: const Color(0xFFF3C5D2),
          surface: Colors.white,
        );

    return MaterialApp(
      title: 'Student TaskMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFFFF9FA),
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFBE7ED),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFF8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF0E4E7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFF0E4E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: pink, width: 1.5),
          ),
        ),
      ),
      home: const TaskMateShell(),
    );
  }
}

class TaskMateShell extends StatefulWidget {
  const TaskMateShell({super.key});

  @override
  State<TaskMateShell> createState() => _TaskMateShellState();
}

class _TaskMateShellState extends State<TaskMateShell> {
  int _selectedIndex = 0;
  late final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Research paper outline',
      subject: 'Psychology',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    TaskItem(
      title: 'Chapter 4 problem set',
      subject: 'Statistics',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    TaskItem(
      title: 'Group presentation slides',
      subject: 'Communication',
      dueDate: DateTime.now().add(const Duration(days: 4)),
      isCompleted: true,
    ),
  ];

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.assignment_outlined),
      selectedIcon: Icon(Icons.assignment_rounded),
      label: 'Tasks',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month_rounded),
      label: 'Schedule',
    ),
    NavigationDestination(
      icon: Icon(Icons.check_circle_outline_rounded),
      selectedIcon: Icon(Icons.check_circle_rounded),
      label: 'Done',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      selectedIcon: Icon(Icons.person_rounded),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(tasks: _tasks, onAddTask: _showAddTaskDialog),
      SectionScreen(
        title: 'Assignments',
        subtitle: 'Keep an eye on what is coming up.',
        icon: Icons.assignment_rounded,
        tasks: _tasks.where((task) => !task.isCompleted).toList(),
        emptyMessage: 'You are all caught up!',
      ),
      const SectionScreen(
        title: 'Class schedule',
        subtitle: 'A quick look at today on campus.',
        icon: Icons.calendar_month_rounded,
        scheduleItems: [
          ('09:00 AM', 'Introduction to Psychology', 'Room 204'),
          ('11:30 AM', 'Statistics', 'Science Hall 3'),
          ('02:00 PM', 'Communication Studies', 'Room 108'),
        ],
      ),
      SectionScreen(
        title: 'Completed tasks',
        subtitle: 'A little progress adds up.',
        icon: Icons.check_circle_rounded,
        tasks: _tasks.where((task) => task.isCompleted).toList(),
        emptyMessage: 'Completed assignments will show up here.',
      ),
      const SectionScreen(
        title: 'Your profile',
        subtitle: 'Your study space, just the way you like it.',
        icon: Icons.person_rounded,
        profile: true,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_selectedIndex]),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddTaskDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add task'),
              backgroundColor: StudentTaskMateApp.pink,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: _destinations,
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    final task = await showModalBottomSheet<TaskItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const _AddTaskSheet(),
    );

    if (task != null && mounted) {
      setState(() => _tasks.add(task));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added to your list')));
    }
  }
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9DDE0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Add a task',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Make a little room for what matters.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 22),
            TextFormField(
              key: const ValueKey('task-title-input'),
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Task title',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a task title'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('task-subject-input'),
              controller: _subjectController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(Icons.menu_book_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a subject'
                  : null,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickDueDate,
              icon: const Icon(Icons.event_outlined),
              label: Text('Due ${formatTaskDate(_dueDate)}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8F5366),
                side: const BorderSide(color: Color(0xFFF0D7E0)),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _saveTask,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Save task'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TaskItem(
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        dueDate: _dueDate,
      ),
    );
  }
}
