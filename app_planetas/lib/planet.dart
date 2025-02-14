class Planet {
  String name;
  double distance;
  double size;
  String? nickname;
  String? imageUrl; // Adicionando URL da imagem do planeta

  Planet({
    required this.name,
    required this.distance,
    required this.size,
    this.nickname,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'distance': distance,
        'size': size,
        'nickname': nickname,
        'imageUrl': imageUrl,
      };

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'],
      distance: json['distance'],
      size: json['size'],
      nickname: json['nickname'],
      imageUrl: json['imageUrl'],
    );
  }
}
