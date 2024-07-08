class User {
  final String id;
  final String email;
  final String username;
  final String? photoURL;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.photoURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      photoURL: json['photoURL'],
    );
  }
}