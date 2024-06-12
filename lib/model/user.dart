class User {
  final int id;
  String _username;
  String _email;
  String _firstname;
  String _lastname;

  User({
    required this.id,
    required String username,
    required String email,
    required String firstname,
    required String lastname,
  })  : _username = username,
        _email = email,
        _firstname = firstname,
        _lastname = lastname;

  // Getters
  String get username => _username;
  String get email => _email;
  String get firstname => _firstname;
  String get lastname => _lastname;

  // Setters
  set username(String username) {
    _username = username;
  }

  set email(String email) {
    _email = email;
  }

  set firstname(String firstname) {
    _firstname = firstname;
  }

  set lastname(String lastname) {
    _lastname = lastname;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': _username,
      'email': _email,
      'firstname': _firstname,
      'lastname': _lastname,
    };
  }
}
