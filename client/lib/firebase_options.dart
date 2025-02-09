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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDCjHKO09Jnb6fS3UYSZycb2NJCL8SyZFY',
    appId: '1:636125235809:web:76209c3b153cdda505f820',
    messagingSenderId: '636125235809',
    projectId: 'projectnex-472c3',
    authDomain: 'projectnex-472c3.firebaseapp.com',
    databaseURL: 'https://projectnex-472c3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'projectnex-472c3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAP20oxx2jPaQRP-7n7f0dAk2-6y5as-xE',
    appId: '1:636125235809:android:80072960416c57f805f820',
    messagingSenderId: '636125235809',
    projectId: 'projectnex-472c3',
    databaseURL: 'https://projectnex-472c3-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'projectnex-472c3.firebasestorage.app',
  );
}
