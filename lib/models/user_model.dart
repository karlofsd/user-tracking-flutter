import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.name, required this.email, this.id, this.token});

  final int? id;
  final String name;
  final String email;
  final String? token;

  @override
  List<Object?> get props => [id, name, email, token];

  @override
  String toString() => 'User{id:$id, name:$name, email:$email, token:$token}';

  factory User.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map is null');
    }
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['token'] = token;

    return map;
  }
}
