class PetDetails {
  final int? id;
  final String name;
  final String breed;
  final String birthdate;
  final String neuter;
  final int weight;
  final String lastSeizure;
  final String meds;
  final String medsFrequency;
  final String about;

  PetDetails({
    this.id,
    required this.name,
    required this.breed,
    required this.birthdate,
    required this.neuter,
    required this.weight,
    required this.lastSeizure,
    required this.meds,
    required this.medsFrequency,
    required this.about,
  });

  factory PetDetails.fromMap(Map<String, dynamic> map) {
    return PetDetails(
      id: map['id'],
      name: map['name'],
      breed: map['breed'],
      birthdate: map['birthdate'],
      neuter: map['neuter'],
      weight: map['weight'],
      lastSeizure: map['lastSeizure'],
      meds: map['meds'],
      medsFrequency: map['medsFrequency'],
      about: map['about'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'birthdate': birthdate,
      'neuter': neuter,
      'weight': weight,
      'lastSeizure': lastSeizure,
      'meds': meds,
      'medsFrequency': medsFrequency,
      'about': about,
    };
  }
}