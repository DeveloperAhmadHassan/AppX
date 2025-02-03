class User {
  String? name;
  String? bio;
  String? gender;
  DateTime? birthdate;
  String? imagePath;

  User({
    this.name,
    this.bio,
    this.gender,
    this.birthdate,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bio': bio,
      'gender': gender,
      'birthdate': birthdate?.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      bio: json['bio'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      imagePath: json['imagePath'],
    );
  }
}
