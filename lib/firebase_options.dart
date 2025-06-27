import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// This class provides Firebase configuration options for different platforms
class DefaultFirebaseOptions {
  // Returns the FirebaseOptions for the current platform
  static FirebaseOptions get currentPlatform {
    // Check if the platform is web
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    // Return platform-specific Firebase options
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

  // Firebase configuration specifically for Android platformv
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDbxoBPL00T-zrHzR7rhs6ITxZUW4PjCM',
    appId: '1:70531817473:android:ca3ed46d94c49a01856000',
    messagingSenderId: '70531817473',
    projectId: 'trend-view-1db97',
    storageBucket: 'trend-view-1db97.firebasestorage.app',
  );
}
