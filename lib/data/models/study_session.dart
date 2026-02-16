class StudySession {
  final int? id;
  final String subject;
  final int duration;
  final String date;

  StudySession({
    this.id,
    required this.subject,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'subject': subject, 'duration': duration, 'date': date};
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'] as int?,
      subject: map['subject'] as String,
      duration: map['duration'] as int,
      date: map['date'] as String,
    );
  }
}
