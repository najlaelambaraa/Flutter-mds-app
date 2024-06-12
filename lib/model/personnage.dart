class Character {
  final int id;
  String name;
  String? description;
  String? imageUrl;

  Character({required this.id, required this.name, required this.description, this.imageUrl});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
    };
  }
}
