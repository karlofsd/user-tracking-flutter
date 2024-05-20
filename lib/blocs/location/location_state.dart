part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState({this.currentAddress, this.suggestions = const []});

  final List<UserLocation> suggestions;
  final UserLocation? currentAddress;

  @override
  List<Object?> get props => [currentAddress, suggestions];
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class MapLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  const LocationSuccess({required super.currentAddress, super.suggestions});

  @override
  List<Object> get props => [currentAddress!, suggestions];
  LocationSuccess copyWith(
      {UserLocation? address, List<UserLocation>? suggestions}) {
    return LocationSuccess(
        currentAddress: address ?? currentAddress,
        suggestions: suggestions ?? super.suggestions);
  }
}

final class LocationSaving extends LocationState {}

final class LocationSaved extends LocationState {
  const LocationSaved({required super.currentAddress});

  @override
  List<Object> get props => [currentAddress!];
}

final class LocationFailed extends LocationState {}
