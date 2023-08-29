import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/home/home_category.dart';
import 'package:jd_demo/home/home_grid_category.dart';
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

  // 瀑布流测试数据count
  late ValueNotifier<int> _gridCountNotifier;

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
    _gridCountNotifier = ValueNotifier(12);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _gridCountNotifier.dispose();
    super.dispose();
  }

  Widget _buildContent(BuildContext context) {
    // 高度随机的grid瀑布流、性能较差
    Widget buildRandomGrid(int count) {
      return SliverToBoxAdapter(
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(count, (index) {
            final randomHeight = Random().nextInt(100) + 200;
            return Container(
                height: randomHeight.toDouble(),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ));
          }),
        ),
      );
    }

    // 高度固定的grid瀑布流、性能较好
    Widget buildSliverGrid(int count) {
      return SliverGrid(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          repeatPattern: QuiltedGridRepeatPattern.mirrored,
          pattern: [
            const QuiltedGridTile(3, 2),
            const QuiltedGridTile(2, 2),
            // const QuiltedGridTile(3, 2),
            // const QuiltedGridTile(3, 2),
            // const QuiltedGridTile(2, 2),
            // const QuiltedGridTile(3, 2),
            // const QuiltedGridTile(2, 2),
          ],
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: count,
          (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              )),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeCategory()),
        SliverToBoxAdapter(
            child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          height: 160,
          color: beautyBgColor,
          child: const Image(image: AssetImage('images/beauty5.jpeg'), fit: BoxFit.fill, alignment: Alignment.center),
        )),
        const SliverToBoxAdapter(child: HomeGirdCategory()),
        SliverToBoxAdapter(
          child: Card(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            shadowColor: Colors.black,
            color: white2,
            elevation: 4,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  '懒得写UI了，就这样吧',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: Row(
          children: [
            Expanded(
                child: Card(
              margin: const EdgeInsets.only(left: 10),
              shadowColor: Colors.black,
              color: white2,
              elevation: 4,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    '懒得写UI了，就这样吧',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Card(
              margin: const EdgeInsets.only(right: 10),
              shadowColor: Colors.black,
              color: white2,
              elevation: 4,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    '懒得写UI了，就这样吧',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
          ],
        )),
        ValueListenableBuilder(
            valueListenable: _gridCountNotifier,
            builder: (_, count, child) => SliverPadding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10), sliver: buildSliverGrid(count))),
      ],
    );
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
        enablePullUp: true,
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
        child: _buildContent(context),
        onRefresh: () async {
          print('-----onRefresh');
          await Future.delayed(const Duration(milliseconds: 1000));
          _gridCountNotifier.value = 12;
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
          _gridCountNotifier.value = _gridCountNotifier.value + 12;
          _refreshController.loadComplete();
        },
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
