class User {
  final String fullname;
  final String email;
  final String username;
  final String password;

  User({
    required this.fullname,
    required this.email,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'username': username,
      'password': password,
    };
  }
}

final List<User> userList = [
  User(
    fullname: 'User Dummy',
    email: 'user1@example.com',
    username: 'user1',
    password: 'password1',
  ),
];
