class PetDetails {
  final int? id;
  final String? name;
  final String? breed;
  final String? birthdate;
  final String? neuter;
  final int? weight;
  final String? lastSeizure;
  final String? meds;
  final String? medsFrequency;
  final String? about;
  final String? imagePath;

  PetDetails({
    this.id,
    this.name,
    this.breed,
    this.birthdate,
    this.neuter,
    this.weight,
    this.lastSeizure,
    this.meds,
    this.medsFrequency,
    this.about,
    this.imagePath,
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
      imagePath: map['imagePath'],
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
      'imagePath': imagePath,
    };
  }
}