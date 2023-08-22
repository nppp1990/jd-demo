import 'package:flutter/material.dart';
import 'package:jd_demo/common/refresh/jd_refresh_indicator.dart';

class DemoList extends StatelessWidget {
  const DemoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DemoList")),
      body: const Test1(),
    );
  }
}

class Test1 extends StatelessWidget {
  const Test1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 200,
      height: 500,
      child: JdRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("item $index"),
            );
          },
        ),
      ),
    );
  }
}