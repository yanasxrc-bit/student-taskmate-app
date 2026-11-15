import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.tasks, required this.onAddTask, super.key});

  final List<TaskItem> tasks;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList()
      ..sort((first, second) => first.dueDate.compareTo(second.dueDate));
    final upcomingTasks = pendingTasks.take(3).toList();
    final today = DateTime.now();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _WelcomeHeader(today: today),
              const SizedBox(height: 25),
              Text(
                'Your overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  SummaryCard(
                    label: 'Total tasks',
                    value: tasks.length,
                    icon: Icons.checklist_rounded,
                    color: const Color(0xFFE78FA9),
                  ),
                  const SizedBox(width: 10),
                  SummaryCard(
                    label: 'Pending',
                    value: pendingTasks.length,
                    icon: Icons.schedule_rounded,
                    color: const Color(0xFFDA9A56),
                  ),
                  const SizedBox(width: 10),
                  SummaryCard(
                    label: 'Completed',
                    value: completedCount,
                    icon: Icons.task_alt_rounded,
                    color: const Color(0xFF72A994),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionHeading(
                title: 'Upcoming assignments',
                trailing: '${pendingTasks.length} pending',
              ),
              const SizedBox(height: 13),
              if (upcomingTasks.isEmpty)
                const _EmptyTasksCard()
              else
                ...upcomingTasks.map((task) => TaskTile(task: task)),
              const SizedBox(height: 15),
              _SectionHeading(title: "Today's schedule", trailing: '3 classes'),
              const SizedBox(height: 13),
              const _ScheduleCard(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.today});

  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Alex 🌸',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'A fresh start, one task at a time.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: Color(0xFFE78FA9),
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      formatTodayDate(today),
                      style: const TextStyle(
                        color: Color(0xFF795B64),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFBE7ED),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.local_florist_rounded,
            color: Color(0xFFE78FA9),
            size: 25,
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.2),
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFFB36B83),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EmptyTasksCard extends StatelessWidget {
  const _EmptyTasksCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.celebration_rounded, color: Color(0xFF72A994)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nothing due right now. Enjoy the breathing room!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard();

  static const items = [
    ('09:00 AM', 'Introduction to Psychology', 'Room 204'),
    ('11:30 AM', 'Statistics', 'Science Hall 3'),
    ('02:00 PM', 'Communication Studies', 'Room 108'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60404A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++)
            _ScheduleRow(
              time: items[index].$1,
              subject: items[index].$2,
              room: items[index].$3,
              isLast: index == items.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.time,
    required this.subject,
    required this.room,
    required this.isLast,
  });

  final String time;
  final String subject;
  final String room;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF4ECEE))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 66,
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB36B83),
              ),
            ),
          ),
          Container(
            width: 3,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF3C5D2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  room,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
