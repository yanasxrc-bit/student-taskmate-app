import 'package:flutter/material.dart';

import '../models/task_item.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({required this.task, super.key});

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    final accent = task.isCompleted
        ? const Color(0xFF72A994)
        : const Color(0xFFE78FA9);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              task.isCompleted ? Icons.check_rounded : Icons.menu_book_rounded,
              color: accent,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.subject,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            task.isCompleted ? 'Done' : formatTaskDate(task.dueDate),
            style: TextStyle(
              color: task.isCompleted
                  ? const Color(0xFF5C927D)
                  : const Color(0xFF8F5366),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
