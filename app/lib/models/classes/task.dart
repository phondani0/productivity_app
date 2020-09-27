class Task {
  String taskId;
  String title;
  String note;
  DateTime timeToComplete;
  bool completed;
  DateTime deadline;

  Task(this.taskId, this.title, this.completed);

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['id'],
      json['title'],
      json['completed'],
    );
  }
}
