import 'package:flutter/material.dart';
import 'package:jd_demo/common/shiny_text.dart';

class ShinyTextDemo extends StatelessWidget {
  const ShinyTextDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("shiny demo")),
        backgroundColor: Colors.blue,
        body: const Center(
          child: AutoShinyText(
            data: ['1', '2', '3'],
            interval: Duration(seconds: 1),
            width: 80,
            height: 30,
          ),
        ));
  }
}
