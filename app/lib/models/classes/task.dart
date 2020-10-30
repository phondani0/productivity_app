class Task {
  String taskId;
  String title;
  String userId;
  bool completed;

  Task({this.taskId, this.title, this.completed, this.userId});

  factory Task.fromJson(Map<String, dynamic> json) {
    // flutter bug: flutter won't throw error if type mismatch
    var taskId = json['id'];
    return Task(
      taskId: "$taskId",
      title: json['title'],
      completed: json['completed'],
      userId: json['user_id'],
    );
  }
}
