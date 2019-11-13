import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsStateIdle> {
  final FirebaseAnalytics _analytics;
  final FirebaseAnalyticsObserver _analyticsObserver;
  final Crashlytics _crashlytics;

  AnalyticsBloc({
    @required FirebaseAnalytics analytics,
    @required FirebaseAnalyticsObserver analyticsObserver,
    @required Crashlytics crashlytics,
  })  : this._analytics = analytics,
        this._analyticsObserver = analyticsObserver,
        this._crashlytics = crashlytics;

  @override
  AnalyticsStateIdle get initialState =>
      AnalyticsStateIdle(analyticsObserver: _analyticsObserver);

  // @override
  // Stream<AnalyticsState> transform(events, next) {
  //   final observableStream = events as Observable<AnalyticsEvent>;

  //   final nonDebounceStream = observableStream.where((event) {
  //     return (event is! AnalyticsEventSearch);
  //   });

  //   final debounceStream = observableStream.where((event) {
  //     return (event is AnalyticsEventSearch);
  //   }).debounceTime(
  //     Duration(seconds: 2),
  //   );
  //   return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  // }

  @override
  Stream<AnalyticsStateIdle> mapEventToState(AnalyticsEvent event) async* {
    if (event is AnalyticsEventSetUserDetails) {
      await _analytics.setUserId(event.userId);
      await _crashlytics.setUserIdentifier(event.userId);
      await _crashlytics.setUserEmail(event.email);
      await _crashlytics.setUserName(event.username);
    } else if (event is AnalyticsEventSetUserProperty) {
      await _analytics.setUserProperty(
        name: event.name,
        value: event.value,
      );
    } else if (event is AnalyticsEventLogin) {
      await _analytics.logEvent(name: 'login', parameters: {
        'method': event.method,
        'status': event.status,
      });
    } else if (event is AnalyticsEventScreenView) {
      await _analytics.setCurrentScreen(screenName: event.screenName);
    } else if (event is AnalyticsEventSearch) {
      await _analytics.logSearch(
        origin: event.searchCategory?.toString(),
        searchTerm: event.searchTerm,
      );
    } else if (event is AnalyticsEventViewItemList) {
      await _analytics.logViewItemList(
        itemCategory: event.itemCategory?.toString(),
      );
    } else if (event is AnalyticsEventViewItem) {
      await _analytics.logViewItem(
        itemName: event.itemName,
        itemCategory: event.itemCategory?.toString(),
        itemId: event.itemId,
        searchTerm: event.searchTerm,
      );
    } else if (event is AnalyticsEventSelectContent) {
      await _analytics.logSelectContent(
        contentType: event.contentType,
        itemId: event.itemId,
      );
    }

    yield state;
  }
}

abstract class AnalyticsEvent extends Equatable {}

class AnalyticsEventSetUserDetails extends AnalyticsEvent {
  final String userId;
  final String username;
  final String email;
  AnalyticsEventSetUserDetails({this.userId, this.username, this.email});
  @override
  List<Object> get props => [userId, username, email];
}

class AnalyticsEventSetUserProperty extends AnalyticsEvent {
  final String name;
  final String value;
  AnalyticsEventSetUserProperty(this.name, this.value);
  @override
  List<Object> get props => [name, value];
}

class AnalyticsEventLogin extends AnalyticsEvent {
  final String method;
  final String status;
  AnalyticsEventLogin(this.method, this.status);
  @override
  List<Object> get props => [method, status];
}

class AnalyticsEventScreenView extends AnalyticsEvent {
  final String screenName;
  AnalyticsEventScreenView(this.screenName);
  @override
  List<Object> get props => [screenName];
}

class AnalyticsEventSearch extends AnalyticsEvent {
  final String searchTerm;
  final String searchCategory;
  AnalyticsEventSearch(this.searchTerm, this.searchCategory);
  @override
  List<Object> get props => [searchTerm, searchCategory];
}

class AnalyticsEventViewItem extends AnalyticsEvent {
  final String itemCategory;
  final String itemName;
  final String itemId;
  final String searchTerm;
  AnalyticsEventViewItem({
    this.itemCategory,
    this.itemName,
    this.itemId,
    this.searchTerm,
  });
  @override
  List<Object> get props => [itemCategory, itemName, itemId, searchTerm];
}

class AnalyticsEventSelectContent extends AnalyticsEvent {
  final String itemId;
  final String contentType;
  AnalyticsEventSelectContent({this.itemId, this.contentType});
  @override
  List<Object> get props => [itemId, contentType];
}

class AnalyticsEventViewItemList extends AnalyticsEvent {
  final String itemCategory;
  AnalyticsEventViewItemList({this.itemCategory});
  @override
  List<Object> get props => [itemCategory];
}

class AnalyticsStateIdle extends Equatable {
  final FirebaseAnalyticsObserver analyticsObserver;
  AnalyticsStateIdle({this.analyticsObserver});
  @override
  List<Object> get props => [analyticsObserver];
}
