import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDZdTTNv4_29MMyYiJabMa8NIn5DjooOH8',
    appId: '1:668323220823:web:4475e5ab4361cb0d258212',
    messagingSenderId: '668323220823',
    projectId: 'leaf-app-4bc6e',
    authDomain: 'leaf-app-4bc6e.firebaseapp.com',
    storageBucket: 'leaf-app-4bc6e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZdTTNv4_29MMyYiJabMa8NIn5DjooOH8',
    appId: '1:668323220823:android:4475e5ab4361cb0d258212',
    messagingSenderId: '668323220823',
    projectId: 'leaf-app-4bc6e',
    storageBucket: 'leaf-app-4bc6e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZdTTNv4_29MMyYiJabMa8NIn5DjooOH8',
    appId: '1:668323220823:ios:placeholder',
    messagingSenderId: '668323220823',
    projectId: 'leaf-app-4bc6e',
    storageBucket: 'leaf-app-4bc6e.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZdTTNv4_29MMyYiJabMa8NIn5DjooOH8',
    appId: '1:668323220823:ios:placeholder',
    messagingSenderId: '668323220823',
    projectId: 'leaf-app-4bc6e',
    storageBucket: 'leaf-app-4bc6e.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZdTTNv4_29MMyYiJabMa8NIn5DjooOH8',
    appId: '1:668323220823:web:4475e5ab4361cb0d258212',
    messagingSenderId: '668323220823',
    projectId: 'leaf-app-4bc6e',
    storageBucket: 'leaf-app-4bc6e.firebasestorage.app',
  );
}
