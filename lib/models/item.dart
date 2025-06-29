class Item {
  final String userId;
  int film;
  int specialFilm;

  Item({required this.userId, this.film = 10, this.specialFilm = 10});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    userId: json['user_id'] as String,
    film: json['film'] as int? ?? 10,
    specialFilm: json['special_film'] as int? ?? 10,
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'film': film,
    'special_film': specialFilm,
  };
} 