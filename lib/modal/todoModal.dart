class TodoModal{
  final int id;
  final String title;
  final bool completed;

  TodoModal({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModal.fromJson(Map<String, dynamic> json) {
    return TodoModal(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}