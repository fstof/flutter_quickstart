import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SampleTabNavigationScreenBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => TabState(0);

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    yield (TabState(event.newTab));
  }
}

class TabEvent extends Equatable {
  final int newTab;
  TabEvent(this.newTab);
  @override
  List<Object> get props => [newTab];
  @override
  String toString() => newTab.toString();
}

class TabState extends Equatable {
  final int currentTab;
  TabState(this.currentTab);
  @override
  List<Object> get props => [currentTab];
  @override
  String toString() => currentTab.toString();
}
