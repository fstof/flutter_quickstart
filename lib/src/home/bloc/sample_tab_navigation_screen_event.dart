part of 'sample_tab_navigation_screen_bloc.dart';

class TabEvent extends Equatable {
  final int newTab;
  TabEvent(this.newTab);
  @override
  List<Object> get props => [newTab];
  @override
  String toString() => newTab.toString();
}
