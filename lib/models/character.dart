class Character {
  final int id;
  final String name;
  final String image;
  final String status;
  final String species;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      species: json['species'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'species': species,
    };
  }
}
