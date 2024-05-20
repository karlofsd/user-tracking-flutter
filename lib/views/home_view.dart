import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_tracking_flutter/blocs/auth/auth_bloc.dart';
import 'package:user_tracking_flutter/blocs/location/location_bloc.dart';
import 'package:user_tracking_flutter/repositories/location_repository.dart';
import 'package:user_tracking_flutter/widgets/button_widget.dart';
import 'package:user_tracking_flutter/widgets/input_text_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  final TextEditingController _searchController = TextEditingController();

  bool isShowSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(LocationRepository(),
          userId: context.read<AuthBloc>().state.user!.id!)
        ..add(const LoadLocationEvent()),
      child: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state.runtimeType == LocationSaved) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Address saved successfully")));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('UserTracking'),
              elevation: 0,
              clipBehavior: Clip.none,
              actions: [
                IconButton(
                    onPressed: () {
                      context
                          .read<LocationBloc>()
                          .add(const LoadLocationEvent());
                    },
                    icon: const Icon(Icons.refresh)),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: const Text('Do you want to logout?'),
                                actions: [
                                  Button(
                                    color: Colors.red,
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Button(
                                    child: const Text('Confirm'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context
                                          .read<AuthBloc>()
                                          .add(LogoutEvent());
                                    },
                                  )
                                ],
                              ));
                    },
                    icon: const Icon(Icons.logout_rounded))
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .add(const EdgeInsets.only(bottom: 8)),
                  child: InputText(
                    controller: _searchController,
                    label: "Search",
                    onFieldSubmitted: (value) {
                      if (_searchController.text.isEmpty) return;
                      context
                          .read<LocationBloc>()
                          .add(GetSuggestionsEvent(address: value));
                      setState(() {
                        isShowSuggestions = true;
                      });
                    },
                    suffix: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_searchController.text.isEmpty) return;

                        context.read<LocationBloc>().add(GetSuggestionsEvent(
                            address: _searchController.text));
                        setState(() {
                          isShowSuggestions = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            body: state.runtimeType == MapLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.runtimeType == LocationFailed
                    ? Container()
                    : Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(40))),
                            width: double.infinity,
                            child: GoogleMap(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 250),
                              // liteModeEnabled: true,
                              // myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: false,
                              onTap: (position) {
                                context.read<LocationBloc>().add(
                                    UpdateLocationEvent(position: position));
                              },
                              markers: {
                                Marker(
                                    draggable: true,
                                    markerId: const MarkerId('marker-key'),
                                    position: LatLng(
                                        state.currentAddress?.latitude ?? 0,
                                        state.currentAddress?.longitude ?? 0))
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      state.currentAddress?.latitude ?? 0,
                                      state.currentAddress?.longitude ?? 0),
                                  zoom: 14),
                              // onMapCreated: (GoogleMapController controller) {
                              //   _controller.complete(controller);
                              // },
                            ),
                          ),
                          state.runtimeType == LocationLoading
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InputText(
                                            label: "Address",
                                            initialValue:
                                                state.currentAddress?.address,
                                            readOnly: true,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InputText(
                                                  label: "Locality",
                                                  initialValue: state
                                                      .currentAddress?.locality,
                                                  readOnly: true,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: InputText(
                                                  label: "City",
                                                  initialValue: state
                                                      .currentAddress?.city,
                                                  readOnly: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Button(
                                                  loading: state.runtimeType ==
                                                      LocationSaving,
                                                  onPressed: () {
                                                    context
                                                        .read<LocationBloc>()
                                                        .add(
                                                            SaveLocationEvent());
                                                  },
                                                  child: const Text(
                                                      'Save location'),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          if (state.runtimeType == LocationLoading)
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(40))),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          if (isShowSuggestions)
                            Positioned(
                              top: -8,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                constraints: BoxConstraints(
                                    maxHeight: 200,
                                    minHeight: isShowSuggestions ? 50 : 0,
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 32),
                                child: Card(
                                  child: state.suggestions.isEmpty
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : ListView(
                                          shrinkWrap: true,
                                          children: state.suggestions
                                              .map((e) => ListTile(
                                                    title: Text(e.address),
                                                    onTap: () {
                                                      setState(() {
                                                        isShowSuggestions =
                                                            false;
                                                      });

                                                      _searchController.clear();
                                                      context
                                                          .read<LocationBloc>()
                                                          .add(
                                                              LoadLocationEvent(
                                                                  location: e));
                                                    },
                                                  ))
                                              .toList(),
                                        ),
                                ),
                              ),
                            ),
                        ],
                      ),
          );
        },
      ),
    );
  }
}
