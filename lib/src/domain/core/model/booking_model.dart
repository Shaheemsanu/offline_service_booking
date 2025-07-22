class BookingModel {
  final String id;
  final String providerId;
  final String date; // e.g. "2025-07-18"
  final String time; // e.g. "14:30"
  final String note;

  BookingModel({
    required this.id,
    required this.providerId,
    required this.date,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toMapWithoutId() {
    return {
      'provider_id': providerId,
      'date': date,
      'time': time,
      'note': note,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider_id': providerId,
      'date': date,
      'time': time,
      'note': note,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id']?.toString() ?? " ",
      providerId: map['provider_id']?.toString() ?? " ",
      date: map['date']?.toString() ?? " ",
      time: map['time']?.toString() ?? " ",
      note: map['note']?.toString() ?? " ",
    );
  }

  String toJson() => toMap().toString();

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel.fromMap(json);
  }

  BookingModel copyWith({
    String? id,
    String? providerId,
    String? date,
    String? time,
    String? note,
  }) {
    return BookingModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, provider_id: $providerId, date: $date, time: $time, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingModel &&
        other.id == id &&
        other.providerId == providerId &&
        other.date == date &&
        other.time == time &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        providerId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        note.hashCode;
  }
}
