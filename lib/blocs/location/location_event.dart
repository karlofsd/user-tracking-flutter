part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

final class LoadLocationEvent extends LocationEvent {
  final UserLocation? location;

  const LoadLocationEvent({this.location});
}

final class UpdateLocationEvent extends LocationEvent {
  final LatLng position;

  const UpdateLocationEvent({this.position = const LatLng(0, 0)});
}

final class GetSuggestionsEvent extends LocationEvent {
  final String? address;

  const GetSuggestionsEvent({this.address});
}

final class SaveLocationEvent extends LocationEvent {}
