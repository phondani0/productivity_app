class Task {
  String taskId;
  String title;
  String userId;
  bool completed;

  Task({this.taskId, this.title, this.completed, this.userId});

  factory Task.fromJson(Map<String, dynamic> json) {
    // flutter bug: flutter won't throw error if type mismatch
    return Task(
      taskId: "$json['id']",
      title: json['title'],
      completed: json['completed'],
      userId: json['user_id'],
    );
  }
}
