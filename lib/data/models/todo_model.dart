class TodoModel {
  final int? id;
  final String? task;
  final String? date;
  final bool isCompleted;

  TodoModel({
    this.id,
    required this.task,
    required this.date,
    this.isCompleted = false
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      task: map['task'],
      date: map['date'],
      isCompleted: map['is_Completed'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'date': date,
      'is_Completed': isCompleted ? 1 : 0,
    };
  }
}
