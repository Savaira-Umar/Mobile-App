class TaskItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String date;
  final String iconKey;
  final bool isDone;
  final bool isDue;
  final String? goalId;
  final String? goalTitle;
  final int reminderMinutes;
  final int commentCount;
  final String ownerUserId;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.iconKey,
    this.isDone = false,
    this.isDue = false,
    this.goalId,
    this.goalTitle,
    this.reminderMinutes = 0,
    this.commentCount = 0,
    required this.ownerUserId,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? date,
    String? iconKey,
    bool? isDone,
    bool? isDue,
    String? goalId,
    String? goalTitle,
    int? reminderMinutes,
    int? commentCount,
    String? ownerUserId,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
      iconKey: iconKey ?? this.iconKey,
      isDone: isDone ?? this.isDone,
      isDue: isDue ?? this.isDue,
      goalId: goalId ?? this.goalId,
      goalTitle: goalTitle ?? this.goalTitle,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      commentCount: commentCount ?? this.commentCount,
      ownerUserId: ownerUserId ?? this.ownerUserId,
    );
  }
}

class GoalItem {
  final String id;
  final String title;
  final String description;
  final String targetDate;
  final String iconKey;
  final int completedTasks;
  final int totalTasks;
  final String ownerUserId;

  const GoalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.iconKey,
    required this.completedTasks,
    required this.totalTasks,
    required this.ownerUserId,
  });

  GoalItem copyWith({
    String? id,
    String? title,
    String? description,
    String? targetDate,
    String? iconKey,
    int? completedTasks,
    int? totalTasks,
    String? ownerUserId,
  }) {
    return GoalItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      iconKey: iconKey ?? this.iconKey,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      ownerUserId: ownerUserId ?? this.ownerUserId,
    );
  }
}

class CommentItem {
  final String id;
  final String taskId;
  final String authorName;
  final bool isMine;
  final String text;
  final String timestamp;

  const CommentItem({
    required this.id,
    required this.taskId,
    required this.authorName,
    required this.isMine,
    required this.text,
    required this.timestamp,
  });
}

class DummyData {
  DummyData._();

  // Savaira's Sample Goals
  static final List<GoalItem> initialGoals = [
    const GoalItem(
      id: 'g1',
      title: 'Improve English',
      description: 'Daily speaking practice and reading advanced vocabulary',
      targetDate: '30 Nov 2026',
      iconKey: 'book',
      completedTasks: 3,
      totalTasks: 5,
      ownerUserId: 'savaira',
    ),
    const GoalItem(
      id: 'g2',
      title: 'Learn Programming',
      description: 'Master Flutter UI patterns, Riverpod state, and clean code',
      targetDate: '15 Dec 2026',
      iconKey: 'laptop',
      completedTasks: 4,
      totalTasks: 6,
      ownerUserId: 'savaira',
    ),
    const GoalItem(
      id: 'g3',
      title: 'Stay Healthy',
      description: 'Morning brisk walk, hydration, and mindful nutrition',
      targetDate: '31 Dec 2026',
      iconKey: 'dumbbell',
      completedTasks: 2,
      totalTasks: 4,
      ownerUserId: 'savaira',
    ),
    const GoalItem(
      id: 'g4',
      title: 'Complete My Studies',
      description: 'Final semester assignments, lab work, and exam prep',
      targetDate: '20 Jan 2027',
      iconKey: 'pencil',
      completedTasks: 5,
      totalTasks: 8,
      ownerUserId: 'savaira',
    ),
  ];

  // Savaira's Sample Today Tasks (3 done out of 5 total -> "3/5")
  static final List<TaskItem> initialTodayTasks = [
    const TaskItem(
      id: 't1',
      title: 'Morning Walk & Exercise',
      description: '30 minutes brisk walk in fresh air and stretching',
      time: '07:30 AM',
      date: '23 Nov 2026',
      iconKey: 'dumbbell',
      isDone: true,
      goalId: 'g3',
      goalTitle: 'Stay Healthy',
      reminderMinutes: 5,
      commentCount: 2,
      ownerUserId: 'savaira',
    ),
    const TaskItem(
      id: 't2',
      title: 'Study English Vocabulary',
      description: 'Read editorial article and note down 10 new words',
      time: '09:00 AM',
      date: '23 Nov 2026',
      iconKey: 'book',
      isDone: true,
      goalId: 'g1',
      goalTitle: 'Improve English',
      reminderMinutes: 10,
      commentCount: 1,
      ownerUserId: 'savaira',
    ),
    const TaskItem(
      id: 't3',
      title: 'Flutter UI Implementation',
      description: 'Design all navigation shell screens and custom widgets',
      time: '11:30 AM',
      date: '23 Nov 2026',
      iconKey: 'laptop',
      isDone: true,
      goalId: 'g2',
      goalTitle: 'Learn Programming',
      reminderMinutes: 0,
      commentCount: 0,
      ownerUserId: 'savaira',
    ),
    const TaskItem(
      id: 't4',
      title: 'Water Plants & Clean Desk',
      description: 'Tidy up room balcony plants and organize workspace',
      time: '04:15 PM',
      date: '23 Nov 2026',
      iconKey: 'plant',
      isDone: false,
      isDue: true,
      reminderMinutes: 15,
      commentCount: 1,
      ownerUserId: 'savaira',
    ),
    const TaskItem(
      id: 't5',
      title: 'Evening Tea & Review Notes',
      description: 'Relax with family and write reflections for the day',
      time: '06:30 PM',
      date: '23 Nov 2026',
      iconKey: 'cup',
      isDone: false,
      isDue: false,
      goalId: 'g4',
      goalTitle: 'Complete My Studies',
      reminderMinutes: 5,
      commentCount: 0,
      ownerUserId: 'savaira',
    ),
  ];

  // User 2 (Ayesha) Sample Tasks (View Only)
  static final List<TaskItem> user2Tasks = [
    const TaskItem(
      id: 'u2_t1',
      title: 'University Lectures & Lab',
      description: 'Attend morning software engineering lectures',
      time: '08:45 AM',
      date: '23 Nov 2026',
      iconKey: 'laptop',
      isDone: true,
      ownerUserId: 'user2',
      commentCount: 1,
    ),
    const TaskItem(
      id: 'u2_t2',
      title: 'Research Paper Reading',
      description: 'Review Chapter 4 literature on data privacy',
      time: '12:00 PM',
      date: '23 Nov 2026',
      iconKey: 'book',
      isDone: true,
      ownerUserId: 'user2',
      commentCount: 0,
    ),
    const TaskItem(
      id: 'u2_t3',
      title: 'Evening Walk & Meditation',
      description: 'Rest eyes and take fresh air outside',
      time: '05:30 PM',
      date: '23 Nov 2026',
      iconKey: 'run',
      isDone: false,
      isDue: true,
      ownerUserId: 'user2',
      commentCount: 2,
    ),
    const TaskItem(
      id: 'u2_t4',
      title: 'Call Savaira',
      description: 'Daily check-in and share updates about day',
      time: '08:00 PM',
      date: '23 Nov 2026',
      iconKey: 'phone',
      isDone: false,
      isDue: false,
      ownerUserId: 'user2',
      commentCount: 3,
    ),
  ];

  // Sample Comments
  static final List<CommentItem> sampleComments = [
    const CommentItem(
      id: 'c1',
      taskId: 't1',
      authorName: 'Ayesha',
      isMine: false,
      text: 'Great job waking up early today! Keep up the routine 💪',
      timestamp: '08:15 AM',
    ),
    const CommentItem(
      id: 'c2',
      taskId: 't1',
      authorName: 'Savaira',
      isMine: true,
      text: 'Thank you! The fresh air was amazing today 🌸',
      timestamp: '08:20 AM',
    ),
    const CommentItem(
      id: 'c3',
      taskId: 't4',
      authorName: 'Ayesha',
      isMine: false,
      text: 'Remember to check on the small money plant too 🌱',
      timestamp: '04:30 PM',
    ),
    const CommentItem(
      id: 'c4',
      taskId: 'u2_t3',
      authorName: 'Savaira',
      isMine: true,
      text: 'Drink water before heading out! Don’t skip it 💕',
      timestamp: '05:40 PM',
    ),
  ];
}
