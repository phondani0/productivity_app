class Task {
  List<Task> tasks;
  String mote;
  DateTime timeToComplete;
  bool completed;
  String repeats;
  DateTime deadline;
  List<DateTime> reminders;
  String taskId;
  String title;

  Task(this.title, this.completed, this.taskId);
}
