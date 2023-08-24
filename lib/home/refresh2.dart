import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeRefreshPage2 extends StatefulWidget {
  const HomeRefreshPage2({super.key});

  @override
  State createState() => _HomeRefreshPage2State();
}

class _HomeRefreshPage2State extends State<HomeRefreshPage2> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getStatusHeight(context) + homeHeader1),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        scrollController: _scrollController,
        header: const ClassicHeader(),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(const Duration(seconds: 2));
          _refreshController.loadComplete();
        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100,
              color: Colors.primaries[index % Colors.primaries.length],
              child: Center(
                child: Text('$index'),
              ),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }
}
