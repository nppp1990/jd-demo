import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/home/home_animation_search.dart';
import 'package:provider/provider.dart';
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
    var homeSearch2Opacity = context.read<HomeSearch2Opacity>();
    super.initState();
    _refreshController = RefreshController();
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset;
        if (_refreshController.headerStatus == RefreshStatus.idle) {
          if (offset < 0) {
            homeSearch2Opacity.opacity = 1;
          } else if (offset < homeLocationHeight) {
            homeSearch2Opacity.opacity = 1 - offset / homeLocationHeight;
          } else {
            homeSearch2Opacity.opacity = 0;
          }
        }
        print('scrollController: ${_scrollController.offset}---statue: ${_refreshController.headerStatus}');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: homeHeaderBgColor2,
      padding: EdgeInsets.only(top: getStatusHeight(context) + homeHeader1, left: 10, right: 10),
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
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeLocation()),
            const SliverToBoxAdapter(child: HomeSearch2()),
            SliverList.builder(
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
          ],
        ),
      ),
    );
  }
}

class HomeLocation extends StatefulWidget {
  const HomeLocation({super.key});

  @override
  State<StatefulWidget> createState() => _HomeLocationState();
}

class _HomeLocationState extends State<HomeLocation> {
  late ValueNotifier<bool> _favoriteNotifier;

  @override
  void initState() {
    super.initState();
    _favoriteNotifier = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: homeLocationHeight,
      child: Row(
        children: [
          const Icon(JdDemoIcons.location, size: 18, color: Colors.white),
          const SizedBox(width: 4),
          const Expanded(
              child: Text('这个定位很长很长很长很长很长很长很长很长很长很长很长很长很长很长',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ))),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.white),
          const SizedBox(width: 4),
          GestureDetector(
              onTap: () {
                _favoriteNotifier.value = !_favoriteNotifier.value;
              },
              child: ValueListenableBuilder<bool>(
                  valueListenable: _favoriteNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return HomeFavorite(isFavorite: value);
                  })),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _favoriteNotifier.dispose();
    super.dispose();
  }
}

class HomeFavorite extends StatelessWidget {
  final bool isFavorite;

  const HomeFavorite({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
        color: isFavorite ? const Color(0x0F000000) : Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isFavorite) const Icon(JdDemoIcons.unFavorite, size: 18, color: Colors.black),
            if (!isFavorite) const SizedBox(width: 2),
            Text(isFavorite ? '已关注' : '关注', style: TextStyle(fontSize: 14, color: isFavorite ? gray2 : Colors.black)),
          ],
        ),
      ),
    );
  }
}
