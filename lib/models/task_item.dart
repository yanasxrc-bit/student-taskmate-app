class TaskItem {
  const TaskItem({
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isCompleted = false,
  });

  final String title;
  final String subject;
  final DateTime dueDate;
  final bool isCompleted;

  TaskItem copyWith({
    String? title,
    String? subject,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskItem(
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskItem &&
        other.title == title &&
        other.subject == subject &&
        other.dueDate.isAtSameMomentAs(dueDate) &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(
    title,
    subject,
    dueDate.millisecondsSinceEpoch,
    isCompleted,
  );
}

String formatTaskDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String formatTodayDate(DateTime date) {
  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
}
