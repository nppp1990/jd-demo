import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/home/home_category.dart';
import 'package:jd_demo/main.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeRefreshPage1 extends StatefulWidget {
  const HomeRefreshPage1({super.key});

  @override
  State createState() => _HomeRefreshPage1State();
}

class _HomeRefreshPage1State extends State<HomeRefreshPage1> {
  late RefreshController _refreshController;
  late ScrollController _scrollController;

  double? _twiceTriggerDistance;

  @override
  void initState() {
    super.initState();
    final HomeHeaderOpacity homeHeaderOpacity = context.read<HomeHeaderOpacity>();
    _refreshController = RefreshController();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_twiceTriggerDistance == null) {
          return;
        }
        // print('-----scroll: ${_scrollController.position.pixels}----mode: ${_refreshController.headerStatus}');

        var pixels = _scrollController.position.pixels;
        if ((_refreshController.headerStatus == RefreshStatus.idle ||
                _refreshController.headerStatus == RefreshStatus.canRefresh) &&
            pixels < 0) {
          homeHeaderOpacity.changeShowBackgroundHead(true);
        } else {
          homeHeaderOpacity.changeShowBackgroundHead(false);
        }

        // twoLevelOpening、RefreshStatus.twoLeveling
        // twoLevelClosing
        if (_refreshController.headerStatus == RefreshStatus.twoLevelOpening ||
            _refreshController.headerStatus == RefreshStatus.twoLeveling ||
            _refreshController.headerStatus == RefreshStatus.refreshing) {
          // 隐藏头部：opacity=0
          homeHeaderOpacity.changeOpacity(0);
        } else if (pixels < -_twiceTriggerDistance!) {
          homeHeaderOpacity.changeOpacity(0);
        } else if (pixels >= 0) {
          homeHeaderOpacity.changeOpacity(1);
        } else {
          homeHeaderOpacity.changeOpacity(1 + pixels / _twiceTriggerDistance!);
        }
      });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomeCategory();
            case 1:
              return Container(
                padding: const EdgeInsets.all(10),
                height: 170,
                color: Colors.white,
                child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage('images/beauty5.jpeg'), fit: BoxFit.fill, alignment: Alignment.center),
                      borderRadius: BorderRadius.circular(10),
                    )),
              );
            case 2:
            case 3:
            case 4:
              return SizedBox(
                height: 50,
                child: Center(
                    child: Text('todo$index', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
              );
            default:
              return Container(
                height: 100,
                color: Colors.primaries[index % Colors.primaries.length],
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    _twiceTriggerDistance ??= homeBackBottomViewHeight - (getStatusHeight(context) + homeHeader1 + homeSearch1);

    return RefreshConfiguration.copyAncestor(
      context: context,
      enableScrollWhenTwoLevel: true,
      maxOverScrollExtent: 120,
      twiceTriggerDistance: _twiceTriggerDistance!,
      headerTriggerDistance: _twiceTriggerDistance! - 40,
      child: SmartRefresher(
        enableTwoLevel: true,
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        scrollController: _scrollController,
        header: TwoLevelHeader(
          releaseText: '下拉更新',
          refreshingText: '更新中...',
          canTwoLevelText: '继续下拉有惊喜',
          completeText: '更新完成',
          twoLevelWidget: const RefreshNextPage(),
          headerOffset: (getStatusHeight(context) + homeHeader1 + homeCategoryHeight),
          wrapHeaderBuilder: (height, RefreshStatus? mode, child) {
            return SizedBox(
              height: height,
              child: Stack(
                children: [
                  RefreshNextPage(hideBottom: mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: child,
                  )
                ],
              ),
            );
          },
        ),
        child: buildContent(context),
        onRefresh: () async {
          print('-----onRefresh');
          await Future.delayed(const Duration(milliseconds: 1000));
          _refreshController.refreshCompleted();
        },
        // onLoading: () async {
        //   print('-----onLoading');
        //   // await Future.delayed(const Duration(milliseconds: 2000));
        //   _refreshController.loadComplete();
        // },
      ),
    );
  }
}

class TestBottom extends StatelessWidget {
  final double paddingBottom;

  const TestBottom({super.key, this.paddingBottom = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: homeBackBottomViewHeight + paddingBottom,
      width: double.infinity,
      color: beautyBgColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: paddingBottom),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '测试：啦啦啦啦啦',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '立即下拉，新品下单免费赢',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class RefreshNextPage extends StatelessWidget {
  final bool hideBottom;

  const RefreshNextPage({super.key, this.hideBottom = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Container(
          color: const Color(0xFFFEDC32),
          child: const Column(
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  '测试文字：上拉回到首页',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
              Image(
                image: AssetImage("images/beauty2.jpg"),
                fit: BoxFit.fill,
              ),
            ],
          ),
        )),
        Container(
            height: homeBackBottomViewHeight,
            color: hideBottom ? beautyBgColor : null,
            child: Offstage(offstage: hideBottom, child: const TestBottom())),
      ],
    );
  }
}
