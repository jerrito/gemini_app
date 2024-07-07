import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestPage extends StatelessWidget {
  final ChangeNotif changeNotif;
  const TestPage({super.key, required this.changeNotif});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              changeNotif.add();
            },
            icon: const Icon(Icons.add)),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed("test2");
              },
              icon: const Icon(Icons.arrow_forward)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ListenableBuilder(
              listenable: changeNotif,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      "d${changeNotif._count.toString()}",
                      style: const TextStyle(color: Colors.amber),
                    ),
                    Text(
                      "d${changeNotif._name}",
                      style: const TextStyle(color: Colors.amber),
                    ),
                  ],
                );
              },
              // child: Text(changeNotif._count.toString()),
            ),
          )
        ],
      ),
    );
  }
}

class TestPage2 extends StatelessWidget {
  final ChangeNotif changeNotif;
  const TestPage2({super.key, required this.changeNotif});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              changeNotif.add();
            },
            icon: const Icon(Icons.add)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ListenableBuilder(
              listenable: changeNotif,
              builder: (context, child) {
                return Column(
                  children: [
                    Text(
                      "d${changeNotif._count.toString()}",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                    Text(
                      "${changeNotif._name}",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                );
              },
              // child: Text(changeNotif._count.toString()),
            ),
          )
        ],
      ),
    );
  }
}

class ChangeNotif extends ChangeNotifier {
  int _count = 0;
  String? _name;

  int get count => _count;

  String get name => _name!;

  set nameAdd(String? name) {
    _name = name;
    notifyListeners();
  }

  void add() {
    _count += 1;
    notifyListeners();
  }
}
