import 'package:flutter/material.dart';
import 'package:jd_demo/demo/demo_frame_callback.dart';
import 'package:jd_demo/demo/demo_nested_scroll.dart';
import 'package:jd_demo/demo/demo_refresh2.dart';
import 'package:jd_demo/demo/demo_shiny.dart';
import 'package:jd_demo/demo/demo_smooth_page_indicator.dart';
import 'package:jd_demo/demo/demo_staggered_grid.dart';
import 'package:jd_demo/demo/demo_two_level_page.dart';

import 'demo_refresh3.dart';


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
            ListTile(
              title: const Text('two level page view'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TwoLevelPageDemo()),
                );
              },
            ),
            ListTile(
              title: const Text('frame callback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestFrameCallback()),
                );
              },
            ),
            ListTile(
              title: const Text('EasyRefresh Demo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabBarViewPage()),
                );
              },
            ),
            ListTile(
              title: const Text('EasyRefresh Demo2'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TabBarViewPage2()),
                );
              },
            ),
            ListTile(
              title: const Text('nested scroll view'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NestedScrollViewDemo1()),
                );
              },
            ),
          ],
        ));
  }
}
