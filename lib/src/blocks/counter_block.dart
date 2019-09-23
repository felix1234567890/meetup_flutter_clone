import 'dart:async';

import 'package:flutter/widgets.dart';

class CounterBloc {
  final StreamController<int> _streamController =
      StreamController<int>.broadcast();
  final StreamController<int> _counterController =
      StreamController<int>.broadcast();

  Stream<int> get counterStream => _counterController.stream;
  StreamSink<int> get counterSink => _counterController.sink;

  int _counter = 0;
  CounterBloc() {
    _streamController.stream.listen((int number) {
      _counter += number;
      counterSink.add(_counter);
    });
  }
  dispose() {
    _streamController.close();
    _counterController.close();
  }

  increment(int number) {
    _streamController.sink.add(number);
  }
}

class CounterBlocProvider extends InheritedWidget {
  final CounterBloc bloc;
  CounterBlocProvider({Widget child, Key key})
      : bloc = CounterBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
