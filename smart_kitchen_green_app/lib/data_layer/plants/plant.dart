class Plant {
  final int id;
  final String name;
  final String category;
  final String bestgrow;
  final String img;

  Plant(
      {required this.id,
      required this.name,
      required this.category,
      required this.bestgrow,
      required this.img});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        bestgrow: json['bestgrow'],
        img: json['img'] != null ? json['img'] : ".jpg");
  }
}
