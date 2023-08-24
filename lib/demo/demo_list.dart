import 'package:flutter/material.dart';
import 'package:jd_demo/demo/demo_shiny.dart';
import 'package:jd_demo/demo/demo_smooth_page_indicator.dart';
import 'package:jd_demo/demo/demo_staggered_grid.dart';


class DemoList extends StatelessWidget {
  const DemoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("DemoList")),
        body: ListView(
          children: [
            ListTile(
              title: const Text('shiny demo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShinyTextDemo()),
                );
              },
            ),
            ListTile(
              title: const Text('page indicator demo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageIndicatorDemo()),
                );
              },
            ),
            ListTile(
              title: const Text('stagger grid'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StaggerGrid()),
                );
              },
            ),
          ],
        ));
  }
}
