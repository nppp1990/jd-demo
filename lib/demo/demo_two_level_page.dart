import 'package:flutter/material.dart';

class TwoLevelPageDemo extends StatefulWidget {
  const TwoLevelPageDemo({super.key});

  @override
  State<StatefulWidget> createState() => _Test();
}

class _Test extends State<TwoLevelPageDemo> {
  late PageController _pageController;
  late ValueNotifier<double> _heightRatioNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        print('page:${_pageController.page}---offset:${_pageController.offset}');
        double page = _pageController.page!;
        // [1, 2, 3]
        _heightRatioNotifier.value = 1 + page;
      });
    _heightRatioNotifier = ValueNotifier(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("two level page demo")),
        backgroundColor: Colors.blue,
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: ValueListenableBuilder(
            valueListenable: _heightRatioNotifier,
            builder: (context, value, child) => Container(
              height: value * 75,
              width: 300,
              color: Colors.white,
              child: child,
            ),
            child: Container(
              height: 75,
              width: 300,
              color: Colors.white,
              child: PageView(
                controller: _pageController,
                children: [
                  GridView.builder(
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, mainAxisSpacing: 0, crossAxisSpacing: 0),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.green,
                          child: Center(
                            child: Text(
                              '$index',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }),
                  GridView.builder(
                      itemCount: 6,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, mainAxisSpacing: 0, crossAxisSpacing: 0),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              '$index',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }),
                  GridView.builder(
                      itemCount: 12,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, mainAxisSpacing: 0, crossAxisSpacing: 0),
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.yellow,
                          child: Center(
                            child: Text(
                              '$index',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
