class Univers {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;

  Univers({required this.id, required this.name, this.imageUrl, this.description});

 set name(String name) {
    name = name;
  }

  factory Univers.fromJson(Map<String, dynamic> json) {
    return Univers(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'] ?? '', // Provide a default empty string if null
      description: json['description'] ?? '', // Provide a default empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'description': description,
    };
  }
}
