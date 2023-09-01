import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TestFrameCallback extends StatefulWidget {
  const TestFrameCallback({super.key});

  @override
  State<StatefulWidget> createState() => _TestFrameCallbackState();
}

class _TestFrameCallbackState extends State<TestFrameCallback> {

  int _count = 3;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      print('frameCallback: $timeStamp----size:${context.size}');
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      print('frameCallback in build: $timeStamp----size:${context.size}--$this');
    });
    return Scaffold(
      body: ListView.builder(
          itemCount: _count,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _count += 3;
                });
              },
              child: Container(
                color: Colors.primaries[index % Colors.primaries.length],
                height: 100,
                child: Center(child: Text('$index')),
              ),
            );
          }),
    );
  }
}
