import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseConfig {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  static Future<void> logPageView(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
  }

  static Future<void> logStreamPlay() async {
    await analytics.logEvent(
      name: 'stream_play',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> logUserLocation(String country, String city) async {
    await analytics.logEvent(
      name: 'user_location',
      parameters: {
        'country': country,
        'city': city,
      },
    );
  }
}
