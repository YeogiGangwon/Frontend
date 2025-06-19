class Place {
  final String id;
  final String name;
  final String image;
  final String description;
  final String location;
  final List<String> tags;
  final String explain;

  Place({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.location,
    required this.tags,
    required this.explain,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'],
      description: json['description'],
      location: json['location'],
      tags: List<String>.from(json['tags']),
      explain: json['explain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'location': location,
      'tags': tags,
      'explain': explain,
    };
  }
}
