class StudySession {
  final int? id;
  final String subject;
  final int? duration;
  final String? date;

  StudySession({
    this.id,
    required this.subject,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'subject': subject, 'duration': duration, 'date': date};
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      subject: map['subject'],
      duration: map['duration'],
      date: map['date'],
    );
  }
}
