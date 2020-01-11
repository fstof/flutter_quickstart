import 'package:bloc/bloc.dart';

import 'sample_tab_navigation_screen_event.dart';
import 'sample_tab_navigation_screen_state.dart';

class SampleTabNavigationScreenBloc extends Bloc<TabEvent, TabState> {
  @override
  TabState get initialState => TabState(0);

  @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    yield (TabState(event.newTab));
  }
}
