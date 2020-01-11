import 'package:equatable/equatable.dart';

class TabState extends Equatable {
  final int currentTab;
  TabState(this.currentTab);
  @override
  List<Object> get props => [currentTab];
  @override
  String toString() => currentTab.toString();
}
