part of 'sample_tab_navigation_screen_bloc.dart';

class TabState extends Equatable {
  final int currentTab;
  TabState(this.currentTab);
  @override
  List<Object> get props => [currentTab];
  @override
  String toString() => currentTab.toString();
}
