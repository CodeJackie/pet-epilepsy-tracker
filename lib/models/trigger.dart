class Trigger {
  final int? triggerId;
  final String triggerName;
  final String? triggerNotes;

  Trigger ({
    this.triggerId,
    required this.triggerName,
    this.triggerNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      if (triggerId != null) 'triggerID': triggerId,
      'triggerName': triggerName,
      'triggerNotes': triggerNotes,
    };
  }

  factory Trigger.fromMap(Map<String, dynamic> map) {
    return Trigger(
      triggerId: map['triggerID'] as int?,
      triggerName: map['triggerName'] as String,
      triggerNotes: map['triggerNotes'] as String?
    );
  }
}