import 'package:flutter_quick_start/src/home/bloc/sample_tab_navigation_screen_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Test Tab Navigation Screen Bloc:', () {
    SampleTabNavigationScreenBloc bloc;

    setUp(() {
      bloc = SampleTabNavigationScreenBloc();
    });

    test('test initial state', () async {
      expect(bloc.state, TabState(0));
    });

    test('test tab change event', () async {
      when(bloc);

      bloc.add(TabEvent(1));
      bloc.add(TabEvent(2));
      bloc.add(TabEvent(3));

      await expectLater(
        bloc,
        emitsInOrder([
          TabState(0),
          TabState(1),
          TabState(2),
          TabState(3),
        ]),
      );
    });
  });
}
