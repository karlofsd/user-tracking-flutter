// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserLocation extends Equatable {
  final int? id;
  final String address;
  final String? locality;
  final String? city;
  final double latitude;
  final double longitude;

  const UserLocation({
    this.id,
    required this.address,
    this.locality,
    this.city,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'locality': locality,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw Exception('Map is null');
    }
    return UserLocation(
      id: map['id'] != null ? map['id'] as int : null,
      address: map['address'] as String,
      locality: map['locality'] != null ? map['locality'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      latitude: double.tryParse(map['latitude'].toString()) ?? 0,
      longitude: double.tryParse(map['longitude'].toString()) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocation.fromJson(String source) =>
      UserLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      id,
      address,
      locality,
      city,
      latitude,
      longitude,
    ];
  }

  UserLocation copyWith({
    int? id,
    String? address,
    String? locality,
    String? city,
    double? latitude,
    double? longitude,
  }) {
    return UserLocation(
      id: id ?? this.id,
      address: address ?? this.address,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool get stringify => true;
}
