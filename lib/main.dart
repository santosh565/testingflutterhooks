import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

void testIt() {
  final values = [1, 2, null, 3];
  // final nonNullValues = values.compactMap();
  // debugPrint(nonNullValues.toString());
  // final nonNullValues = values.compactMap((e) {
  //   if (e != null && e > 10) {
  //     return e;
  //   } else {
  //     return null;
  //   }
  // });
}

void main() {
  testIt();
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

class MyHomePage extends HookWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final image =
    // useFuture(NetworkAssetBundle(Uri.parse(url))
    //     .load(url)
    //     .then((data) => data.buffer.asUint8List())
    //     .then(
    //       (data) => Image.memory(data),
    //     ));

    final future = useMemoized((() => NetworkAssetBundle(Uri.parse(url))
        .load(url)
        .then((data) => data.buffer.asUint8List())
        .then(
          (data) => Image.memory(data),
        )));

    final snapShot = useFuture(future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          snapShot.data,
        ].compactMap().toList(),
      ),
    );
  }
}
