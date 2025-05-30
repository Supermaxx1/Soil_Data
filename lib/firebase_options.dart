// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAjp44g0-FgBdApmYnR_RXMJSfkIVdmopw',
    appId: '1:971526485142:web:567a72541db069ff9b3eb7',
    messagingSenderId: '971526485142',
    projectId: 'farmer-help-8e7d9',
    authDomain: 'farmer-help-8e7d9.firebaseapp.com',
    databaseURL: 'https://farmer-help-8e7d9-default-rtdb.firebaseio.com',
    storageBucket: 'farmer-help-8e7d9.firebasestorage.app',
    measurementId: 'G-1S90RNZ19T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgaLiZ0aznplkdLnhSo5oIBttLpo_pBuQ',
    appId: '1:971526485142:android:1d3d11847e7a14809b3eb7',
    messagingSenderId: '971526485142',
    projectId: 'farmer-help-8e7d9',
    databaseURL: 'https://farmer-help-8e7d9-default-rtdb.firebaseio.com',
    storageBucket: 'farmer-help-8e7d9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqWsVoRI0-Slc-Q_2fVTXDtyKI1pGG9N4',
    appId: '1:971526485142:ios:c25f3b20e6e219799b3eb7',
    messagingSenderId: '971526485142',
    projectId: 'farmer-help-8e7d9',
    databaseURL: 'https://farmer-help-8e7d9-default-rtdb.firebaseio.com',
    storageBucket: 'farmer-help-8e7d9.firebasestorage.app',
    iosBundleId: 'com.example.agriot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqWsVoRI0-Slc-Q_2fVTXDtyKI1pGG9N4',
    appId: '1:971526485142:ios:c25f3b20e6e219799b3eb7',
    messagingSenderId: '971526485142',
    projectId: 'farmer-help-8e7d9',
    databaseURL: 'https://farmer-help-8e7d9-default-rtdb.firebaseio.com',
    storageBucket: 'farmer-help-8e7d9.firebasestorage.app',
    iosBundleId: 'com.example.agriot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAjp44g0-FgBdApmYnR_RXMJSfkIVdmopw',
    appId: '1:971526485142:web:c27013e07932b1a59b3eb7',
    messagingSenderId: '971526485142',
    projectId: 'farmer-help-8e7d9',
    authDomain: 'farmer-help-8e7d9.firebaseapp.com',
    databaseURL: 'https://farmer-help-8e7d9-default-rtdb.firebaseio.com',
    storageBucket: 'farmer-help-8e7d9.firebasestorage.app',
    measurementId: 'G-DVTE29MLL8',
  );
}
