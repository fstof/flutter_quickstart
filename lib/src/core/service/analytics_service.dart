import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver analyticsObserver;
  final FirebaseCrashlytics _crashlytics;

  AnalyticsService({
    @required FirebaseAnalytics analytics,
    @required this.analyticsObserver,
    @required FirebaseCrashlytics crashlytics,
  })  : this._analytics = analytics,
        this._crashlytics = crashlytics;

  void setUserDetails({
    String userId,
    String email,
    String username,
  }) async {
    await _analytics.setUserId(userId.replaceAll(RegExp('[@\.]'), '_'));
    await _crashlytics.setUserIdentifier(userId);
  }

  void setUserProperty({String name, String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  void logLogin({String method, String status}) async {
    await _analytics.logEvent(name: 'login', parameters: {
      'method': method,
      'status': status,
    });
  }

  void logScreenView({String screenName}) async {
    await _analytics.setCurrentScreen(screenName: screenName);
  }

  void logSearch({String searchCategory, String searchTerm}) async {
    await _analytics.logSearch(
      origin: searchCategory?.toString(),
      searchTerm: searchTerm,
    );
  }

  void logViewItemList({String itemCategory}) async {
    await _analytics.logViewItemList(
      itemCategory: itemCategory?.toString(),
    );
  }

  void logViewItem({
    String itemName,
    String itemCategory,
    String itemId,
    String searchTerm,
  }) async {
    await _analytics.logViewItem(
      itemName: itemName,
      itemCategory: itemCategory?.toString(),
      itemId: itemId,
      searchTerm: searchTerm,
    );
  }

  void logSelectContent({String contentType, String itemId}) async {
    await _analytics.logSelectContent(
      contentType: contentType,
      itemId: itemId,
    );
  }
}
