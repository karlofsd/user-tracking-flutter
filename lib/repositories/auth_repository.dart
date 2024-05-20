import 'package:user_tracking_flutter/config/fetch_client.dart';
import 'package:user_tracking_flutter/models/user_model.dart';

class AuthRepository {
  AuthRepository() {
    _client = FetchClient();
  }

  late final FetchClient _client;

  Future<User> login({required String email, required String password}) async {
    const path = 'auth/login';
    final body = {'email': email, 'password': password};
    final userMap = await _client.post(path, body: body);
    return User.fromMap(userMap);
  }

  Future<User> register(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    const path = 'user';
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword
    };
    final userMap = await _client.post(path, body: data);

    return User.fromMap(userMap);
  }
}
