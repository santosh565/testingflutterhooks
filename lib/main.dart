import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

const url =
    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg';

enum Action {
  rotationLeft,
  rotateRight,
  lessVisible,
  moreVisible,
}

@immutable
class State {
  final double rotationDeg, alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotateRight() => State(rotationDeg: rotationDeg + 10, alpha: alpha);
  State rotateLeft() => State(rotationDeg: rotationDeg - 10, alpha: alpha);
  State increaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: min(alpha + 0.1, 1.0));
  State decreaseAlpha() =>
      State(rotationDeg: rotationDeg, alpha: max(alpha - 0.1, 0.0));
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotationLeft:
      return oldState.rotateLeft();
    case Action.rotateRight:
      return oldState.rotateRight();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case null:
      return oldState;
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(reducer,
        initialState: const State.zero(), initialAction: null);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.rotationLeft);
                  },
                  child: const Text('Rotate Left')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.rotateRight);
                  },
                  child: const Text('Rotate Right')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.lessVisible);
                  },
                  child: const Text('- alpha')),
              TextButton(
                  onPressed: () {
                    store.dispatch(Action.moreVisible);
                  },
                  child: const Text('+ alpha'))
            ],
          ),
          const SizedBox(
            height: 150,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360),
              child: Image.network(url),
            ),
          ),
        ],
      ),
    );
  }
}
