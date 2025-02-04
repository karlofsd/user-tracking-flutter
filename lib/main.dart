import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:user_tracking_flutter/app.dart';

void main() {
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   mapsImplementation.useAndroidViewSurface = true;
  //   initializeMapRenderer();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

// Completer<AndroidMapRenderer?>? _initializedRendererCompleter;
//
// /// Initializes map renderer to the `latest` renderer type for Android platform.
// ///
// /// The renderer must be requested before creating GoogleMap instances,
// /// as the renderer can be initialized only once per application context.
// Future<AndroidMapRenderer?> initializeMapRenderer() async {
//   if (_initializedRendererCompleter != null) {
//     return _initializedRendererCompleter!.future;
//   }
//
//   final Completer<AndroidMapRenderer?> completer =
//       Completer<AndroidMapRenderer?>();
//   _initializedRendererCompleter = completer;
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final GoogleMapsFlutterPlatform mapsImplementation =
//       GoogleMapsFlutterPlatform.instance;
//   if (mapsImplementation is GoogleMapsFlutterAndroid) {
//     unawaited(mapsImplementation
//         .initializeWithRenderer(AndroidMapRenderer.latest)
//         .then((AndroidMapRenderer initializedRenderer) =>
//             completer.complete(initializedRenderer)));
//   } else {
//     completer.complete(null);
//   }
//
//   return completer.future;
// }
