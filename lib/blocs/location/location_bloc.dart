import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_tracking_flutter/models/user_location_model.dart';
import 'package:user_tracking_flutter/repositories/location_repository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(LocationRepository locationRepository, {required this.userId})
      : _locationRepository = locationRepository,
        super(LocationInitial()) {
    on<LoadLocationEvent>(_mapLoadLocationEventToState);
    on<UpdateLocationEvent>(_mapUpdateLocationEventToState);
    on<GetSuggestionsEvent>(_mapGetSuggestionsEventToState);
    on<SaveLocationEvent>(_mapSaveLocationEventToState);
  }

  final LocationRepository _locationRepository;
  final int userId;

  FutureOr<void> _mapLoadLocationEventToState(
      LoadLocationEvent event, Emitter<LocationState> emit) async {
    emit(MapLoading());
    final isGranted = await _requestLocationPermission();
    if (!isGranted) {
      emit(LocationFailed());
      return;
    }

    UserLocation? userLocation;

    if (event.location != null) {
      userLocation = event.location;
    } else {
      userLocation = await _locationRepository.getLocation(userId);
    }

    if (userLocation == null) {
      final currentLocation = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(minutes: 10));
      final addresses = await placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      userLocation = UserLocation(
          address: addresses[0].name!,
          locality: addresses[0].locality,
          city: addresses[0].administrativeArea,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);
    }
    emit(LocationSuccess(currentAddress: userLocation));
  }

  FutureOr<void> _mapUpdateLocationEventToState(
      UpdateLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    final addresses = await placemarkFromCoordinates(
        event.position.latitude, event.position.longitude);
    final address = UserLocation(
        address: addresses[0].name!,
        locality: addresses[0].locality,
        city: addresses[0].administrativeArea,
        latitude: event.position.latitude,
        longitude: event.position.longitude);

    emit(LocationSuccess(currentAddress: address, suggestions: const []));
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  FutureOr<void> _mapGetSuggestionsEventToState(
      GetSuggestionsEvent event, Emitter<LocationState> emit) async {
    final locations = await locationFromAddress(event.address ?? '');
    final suggestions = <UserLocation>[];

    for (var location in locations) {
      final places =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      suggestions.add(UserLocation(
          address: places[0].name!,
          locality: places[0].locality,
          city: places[0].administrativeArea,
          latitude: location.latitude,
          longitude: location.longitude));
    }

    emit(LocationSuccess(
        currentAddress: state.currentAddress, suggestions: suggestions));
  }

  FutureOr<void> _mapSaveLocationEventToState(
      SaveLocationEvent event, Emitter<LocationState> emit) async {
    final currAddress = state.currentAddress;
    emit(LocationSaving());
    final location =
        await _locationRepository.saveLocation(userId, location: currAddress!);
    emit(LocationSaved(currentAddress: location));
  }
}
