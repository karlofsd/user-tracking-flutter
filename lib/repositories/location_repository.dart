import 'package:user_tracking_flutter/config/fetch_client.dart';
import 'package:user_tracking_flutter/models/user_location_model.dart';

class LocationRepository {
  LocationRepository() {
    _client = FetchClient();
  }

  late final FetchClient _client;

  Future<UserLocation?> getLocation(int userId) async {
    const path = 'locations';
    final result =
        await _client.get(path, queryParameters: {'user_id': userId});

    try {
      if (result is List) {
        return UserLocation.fromMap(result.firstOrNull);
      }
      return UserLocation.fromMap(result);
    } catch (e) {
      return null;
    }
  }

  Future saveLocation(int userId, {required UserLocation location}) async {
    final path = 'locations/user/$userId';

    final data = location.toMap();

    final locationSaved = await _client.put(path, body: data);

    return UserLocation.fromMap(locationSaved);
  }
}
