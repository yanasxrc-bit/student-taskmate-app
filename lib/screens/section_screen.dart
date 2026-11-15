import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../widgets/task_tile.dart';

class SectionScreen extends StatelessWidget {
  const SectionScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.tasks = const [],
    this.scheduleItems = const [],
    this.emptyMessage,
    this.profile = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<TaskItem> tasks;
  final List<(String, String, String)> scheduleItems;
  final String? emptyMessage;
  final bool profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFBE7ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFFE78FA9)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
        if (profile)
          const _ProfileCard()
        else if (scheduleItems.isNotEmpty)
          ...scheduleItems.map(
            (item) =>
                _ScheduleItem(time: item.$1, subject: item.$2, room: item.$3),
          )
        else if (tasks.isEmpty)
          _EmptySection(message: emptyMessage ?? 'Nothing to show yet.')
        else
          ...tasks.map((task) => TaskTile(task: task)),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.time,
    required this.subject,
    required this.room,
  });

  final String time;
  final String subject;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, color: Color(0xFFE78FA9)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time · $room',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF60404A).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFFFBE7ED),
            child: Icon(
              Icons.person_rounded,
              size: 34,
              color: Color(0xFFE78FA9),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Alex Morgan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4),
          Text('College student', style: TextStyle(color: Color(0xFF8B7B80))),
          SizedBox(height: 20),
          Divider(height: 1, color: Color(0xFFF4ECEE)),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.tune_rounded, color: Color(0xFFE78FA9), size: 20),
              SizedBox(width: 10),
              Text(
                'Preferences',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                'Pink theme',
                style: TextStyle(color: Color(0xFF8B7B80), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.spa_rounded, size: 34, color: Color(0xFFE78FA9)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
