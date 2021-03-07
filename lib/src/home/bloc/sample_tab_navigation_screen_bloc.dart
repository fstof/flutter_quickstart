import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sample_tab_navigation_screen_event.dart';
part 'sample_tab_navigation_screen_state.dart';

class SampleTabNavigationScreenBloc extends Bloc<TabEvent, TabState> {
  SampleTabNavigationScreenBloc() : super(TabState(0));

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    yield (TabState(event.newTab));
  }
}
