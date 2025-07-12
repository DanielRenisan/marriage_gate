class User {
  final String id;
  final String name;
  final int age;
  final String email;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    this.photoUrl,
  });
} 