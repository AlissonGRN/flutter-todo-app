class Task {
  final String id;
  final String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  factory Task.create(String title) {
    return Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );
  }
}
