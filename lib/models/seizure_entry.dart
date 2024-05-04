class SeizureEntry {
  final int? id;
  final String seizureDate;
  final String seizureTime;
  final String seizureCount;
  final String seizureDuration;
  final String seizureTypes;
  final String rescueMed;
  final String regularMed;
  final String preSymptoms;
  final String postSymptoms;
  final String postIctalDuration;
  final String notes;

  SeizureEntry({
    this.id,
    required this.seizureDate,
    required this.seizureTime,
    required this.seizureCount,
    required this.seizureDuration,
    required this.seizureTypes,
    required this.rescueMed,
    required this.regularMed,
    required this.preSymptoms,
    required this.postSymptoms,
    required this.postIctalDuration,
    required this.notes,
  });

  factory SeizureEntry.fromMap(Map<String, dynamic> map) {
      return SeizureEntry(
        id: map['id'],
        seizureDate: map['seizureDate'],
        seizureTime: map['seizureTime'],
        seizureCount: map['seizureCount'],
        seizureDuration: map['seizureDuration'],
        seizureTypes: map['seizureTypes'],
        rescueMed: map['rescueMed'],
        regularMed: map['regularMed'],
        preSymptoms: map['preSymptoms'],
        postSymptoms: map['postSymptoms'],
        postIctalDuration: map['postIctalDuration'],
        notes: map['notes'],
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'seizureDate': seizureDate,
        'seizureTime': seizureTime,
        'seizureCount': seizureCount,
        'seizureDuration': seizureDuration,
        'seizureTypes': seizureTypes,
        'rescueMed': rescueMed,
        'regularMed': regularMed,
        'preSymptoms': preSymptoms,
        'postSymptoms': postSymptoms,
        'postIctalDuration': postIctalDuration,
        'notes': notes,
      };
    }
  }

