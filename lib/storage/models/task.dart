class Task {
  Task(
      {required this.title,
      required this.description,
      required this.date,
      required this.status});

  String title;
  String description;
  String date;
  String status;

  factory Task.fromJson(Map parsedJson) {
    return Task(
      title: parsedJson['title'],
      description: parsedJson['description'],
      date: parsedJson['date'],
      status: parsedJson['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'status': status,
    };
  }
}
