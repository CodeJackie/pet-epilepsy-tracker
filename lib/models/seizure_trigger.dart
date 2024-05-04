class SeizureTrigger {
  final int? id;
  final int seizureId;
  final int triggerId;

  SeizureTrigger({
    this.id,
    required this.seizureId,
    required this.triggerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seizureId': seizureId,
      'triggerId': triggerId,
    };
  }

  factory SeizureTrigger.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('seizureId') || !map.containsKey('triggerId')) {
      throw Exception('Missing data for SeizureTrigger: $map');
    }
    return SeizureTrigger(
      id: map['id'],
      seizureId: map['seizureId'],
      triggerId: map['triggerId'],
    );
  }
}