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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBTplhHTKAig0u4CoXEseC_v64cx3BI-4M',
    appId: '1:46291325751:web:69110e9985c4bb1b3ec0b2',
    messagingSenderId: '46291325751',
    projectId: 'orca-socialmedia-e8c58',
    authDomain: 'orca-socialmedia-e8c58.firebaseapp.com',
    storageBucket: 'orca-socialmedia-e8c58.appspot.com',
    measurementId: 'G-8H7NJKWC4G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhwzjk5LAimeiysNdCn9zgFNP-Ejnita8',
    appId: '1:46291325751:android:bade1315ce0c78a33ec0b2',
    messagingSenderId: '46291325751',
    projectId: 'orca-socialmedia-e8c58',
    storageBucket: 'orca-socialmedia-e8c58.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBTplhHTKAig0u4CoXEseC_v64cx3BI-4M',
    appId: '1:46291325751:web:362be52d77f2d1f73ec0b2',
    messagingSenderId: '46291325751',
    projectId: 'orca-socialmedia-e8c58',
    authDomain: 'orca-socialmedia-e8c58.firebaseapp.com',
    storageBucket: 'orca-socialmedia-e8c58.appspot.com',
    measurementId: 'G-DLCL6SCRVC',
  );

}