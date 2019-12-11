import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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

  /// We need to debounce some analytics events as they could fire way to quick after another (like search while typing)
  @override
  Stream<AnalyticsStateIdle> transformEvents(Stream<AnalyticsEvent> events,
      Stream<AnalyticsStateIdle> Function(AnalyticsEvent event) next) {
    final observableStream = events as Observable<AnalyticsEvent>;

    final debounceStream = observableStream.where((event) {
      return (event is AnalyticsEventSearch);
    }).debounceTime(
      Duration(seconds: 2),
    );

    final nonDebounceStream = observableStream.where((event) {
      return (event is! AnalyticsEventSearch);
    });

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<AnalyticsStateIdle> mapEventToState(AnalyticsEvent event) async* {
    if (event is AnalyticsEventSetUserDetails) {
      await _mapAnalyticsEventSetUserDetailsToState(event);
    } else if (event is AnalyticsEventSetUserProperty) {
      await _mapAnalyticsEventSetUserPropertyToState(event);
    } else if (event is AnalyticsEventLogin) {
      await _mapAnalyticsEventLoginToState(event);
    } else if (event is AnalyticsEventScreenView) {
      await _mapAnalyticsEventScreenViewToState(event);
    } else if (event is AnalyticsEventSearch) {
      await _mapAnalyticsEventSearchToState(event);
    } else if (event is AnalyticsEventViewItemList) {
      await _mapAnalyticsEventViewItemListToState(event);
    } else if (event is AnalyticsEventViewItem) {
      await _mapAnalyticsEventViewItemToState(event);
    } else if (event is AnalyticsEventSelectContent) {
      await _mapAnalyticsEventSelectContentToState(event);
    }

    yield state;
  }

  Future _mapAnalyticsEventSelectContentToState(
      AnalyticsEventSelectContent event) async {
    await _analytics.logSelectContent(
      contentType: event.contentType,
      itemId: event.itemId,
    );
  }

  Future _mapAnalyticsEventViewItemToState(AnalyticsEventViewItem event) async {
    await _analytics.logViewItem(
      itemName: event.itemName,
      itemCategory: event.itemCategory?.toString(),
      itemId: event.itemId,
      searchTerm: event.searchTerm,
    );
  }

  Future _mapAnalyticsEventViewItemListToState(
      AnalyticsEventViewItemList event) async {
    await _analytics.logViewItemList(
      itemCategory: event.itemCategory?.toString(),
    );
  }

  Future _mapAnalyticsEventSearchToState(AnalyticsEventSearch event) async {
    await _analytics.logSearch(
      origin: event.searchCategory?.toString(),
      searchTerm: event.searchTerm,
    );
  }

  Future _mapAnalyticsEventScreenViewToState(
      AnalyticsEventScreenView event) async {
    await _analytics.setCurrentScreen(screenName: event.screenName);
  }

  Future _mapAnalyticsEventLoginToState(AnalyticsEventLogin event) async {
    await _analytics.logEvent(name: 'login', parameters: {
      'method': event.method,
      'status': event.status,
    });
  }

  Future _mapAnalyticsEventSetUserPropertyToState(
      AnalyticsEventSetUserProperty event) async {
    await _analytics.setUserProperty(
      name: event.name,
      value: event.value,
    );
  }

  Future _mapAnalyticsEventSetUserDetailsToState(
      AnalyticsEventSetUserDetails event) async {
    await _analytics.setUserId(event.userId.replaceAll(RegExp('[@\.]'), '_'));
    await _crashlytics.setUserIdentifier(event.userId);
    await _crashlytics.setUserEmail(event.email);
    await _crashlytics.setUserName(event.username);
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
