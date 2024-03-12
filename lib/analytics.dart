import 'package:firebase_analytics/firebase_analytics.dart';

setUserId(FirebaseAnalytics analytics, String userID) {
  analytics.setUserId(id: userID);
}

setCurrentScreen(
    FirebaseAnalytics analytics, String screenName, String screenClass) {
  analytics.setCurrentScreen(
    screenName: screenName,
    screenClassOverride: screenClass,
  );
}

logCustomEvent(FirebaseAnalytics analytics, String name) {
  analytics.logEvent(name: name, parameters: <String, dynamic>{
    'string': 'string',
    'int': 310,
    'long': 1234567890123,
    'double': 310.202102,
    'bool': true,
  });
}
