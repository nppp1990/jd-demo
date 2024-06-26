import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/home/home_animation_search.dart';
import 'package:jd_demo/home/home_grid_category.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeRefreshPage2 extends StatefulWidget {
  const HomeRefreshPage2({super.key});

  @override
  State createState() => _HomeRefreshPage2State();
}

class _HomeRefreshPage2State extends State<HomeRefreshPage2> with SingleTickerProviderStateMixin {
  static const double _anchorDistance = 1000;
  static const _categoryList = [
    '附近门店',
    '逛超市',
    '家电',
    '电脑',
    '生活',
    '服饰',
    '吃喝玩乐',
    '食品',
    '母婴',
    '图书',
    '运动',
    '汽车',
    '服务',
    '拍卖',
    '房产',
  ];

  late EasyRefreshController _refreshController;
  late ScrollController _scrollController;
  late TabController _tabController;

  // 列表页加数据count
  late List<ValueNotifier<int>> _notifierList;
  late ValueNotifier<bool> _showAnchorNotifier;

  final GlobalKey<ExtendedNestedScrollViewState> _nestedScrollKey = GlobalKey();

  @override
  void initState() {
    var homeSearch2Opacity = context.read<HomeSearch2Opacity>();
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset;
        // print('---offset111: $offset}---${_scrollController.position.maxScrollExtent}');
        if (offset < homeLocationHeight) {
          homeSearch2Opacity.opacity = 1 - offset / homeLocationHeight;
        } else {
          homeSearch2Opacity.opacity = 0;
        }
      });
    _notifierList = _categoryList.map((e) => ValueNotifier(10)).toList();
    _showAnchorNotifier = ValueNotifier(false);
    _tabController = TabController(length: _categoryList.length, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          return;
        }
        bool isOuterScrollToMax = _scrollController.offset == _scrollController.position.maxScrollExtent;
        Future.delayed(Duration.zero, () {
          if (isOuterScrollToMax) {
            _checkShowAnchor();
          } else {
            _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200), curve: Curves.ease);
          }
        });
      });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      print('------FrameCallback');
      var innerController = _nestedScrollKey.currentState!.innerController;
      innerController.addListener(() {
        // print('----size:${innerController.positions.length}---offset:${_nestedScrollKey.currentState?.innerPositions.first.pixels}');
        _checkShowAnchor();
      });
    });
  }

  _checkShowAnchor() {
    final offset = _nestedScrollKey.currentState!.innerPositions.first.pixels;
    if (offset >= _anchorDistance) {
      _showAnchorNotifier.value = true;
    } else {
      _showAnchorNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: homeBgColor2,
          padding: EdgeInsets.only(top: getStatusHeight(context) + homeHeader1),
          child: EasyRefresh.builder(
            header: const ClassicHeader(
              position: IndicatorPosition.locator,
              clamping: true,
            ),
            footer: const ClassicFooter(position: IndicatorPosition.locator),
            controller: _refreshController,
            // 因为用的NestedScrollView，所以这里无效
            // scrollController: _scrollController,
            onRefresh: () async {
              print('----onRefresh');
              await Future.delayed(const Duration(seconds: 2));
              for (var notifier in _notifierList) {
                notifier.value = 10;
              }
              _refreshController.resetFooter();
              _refreshController.finishRefresh();
            },
            onLoad: () async {
              await Future.delayed(const Duration(seconds: 2));
              _notifierList[_tabController.index].value += 10;
              _refreshController.finishLoad();
            },
            childBuilder: (BuildContext context, ScrollPhysics physics) {
              return ExtendedNestedScrollView(
                  floatHeaderSlivers: true,
                  onlyOneScrollInBody: true,
                  key: _nestedScrollKey,
                  controller: _scrollController,
                  physics: physics,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        const HeaderLocator.sliver(clearExtent: false),
                        const SliverToBoxAdapter(child: HomeLocation()),
                        SliverPersistentHeader(
                            floating: true,
                            delegate: _HomeHeaderDelegate(
                                height: homeSearch2 + homeCategoryHeight3 + 16, child: const HomeFloatingHeader())),
                        const SliverToBoxAdapter(child: HomeBanner()),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
                          ),
                        ),
                        const SliverToBoxAdapter(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: HomeGridCategoryLayout2(),
                        )),
                        SliverOverlapAbsorber(
                          handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          sliver: SliverPersistentHeader(
                              pinned: true,
                              // floating: true,
                              delegate: _HomeHeaderDelegate(
                                  child: HomeCategoryTabBar(
                                    tabController: _tabController,
                                    data: _categoryList,
                                  ),
                                  height: homeCategoryHeight2)),
                        ),
                      ],
                  // body: Container(color: Colors.yellow,),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: _categoryList.asMap().entries.map((e) {
                      final index = e.key;
                      final name = e.value;
                      return ValueListenableBuilder(
                        valueListenable: _notifierList[index],
                        builder: (context, value, child) {
                          return _AutomaticKeepAlive(
                            child: CustomScrollView(
                              // key: PageStorageKey(name),
                              physics: physics,
                              slivers: [
                                SliverOverlapInjector(
                                    handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    if (index % 4 == 3) {
                                      return Container(
                                        height: 100,
                                        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text('这是广告：$index'),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 200,
                                        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$name：$index',
                                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }
                                  }, childCount: value),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ));
            },
          ),
        ),
        Positioned(
            right: 15,
            bottom: 80,
            child: ValueListenableBuilder(
              valueListenable: _showAnchorNotifier,
              builder: (context, value, child) => Visibility(
                visible: value,
                child: child!,
              ),
              child: GestureDetector(
                  onTap: () {
                    _showAnchorNotifier.value = false;
                    _scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                  },
                  child: const RocketAnchor()),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var notifier in _notifierList) {
      notifier.dispose();
    }
    _showAnchorNotifier.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }
}

class RocketAnchor extends StatelessWidget {
  const RocketAnchor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          JdDemoIcons.rocket,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}

class HomeFloatingHeader extends StatelessWidget {
  static const List<String> categoryList = ['矿泉水', '剃须刀', '口红', '鲜花', '床上用品'];

  const HomeFloatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: homeHeaderBgColor2,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          // homeSearch2
          const HomeSearch2(),
          // homeCategoryHeight3 + 16
          Row(
              children: categoryList.map((category) {
            return Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
              height: homeCategoryHeight3,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 1),
                  color: const Color(0xFFE1E1E1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ]),
              child: Center(
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                ),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _HomeHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
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
    return Container(
      color: homeHeaderBgColor2,
      height: homeLocationHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            Text(isFavorite ? '已关注' : '关注', style: TextStyle(fontSize: 14, color: isFavorite ? grey2 : Colors.black)),
          ],
        ),
      ),
    );
  }
}

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<StatefulWidget> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  static const _bannerList = [
    'images/gdyg1.jpeg',
    'images/gdyg2.jpeg',
    'images/gdyg3.jpg',
    'images/gdyg4.jpg',
  ];

  late LoopPageController _loopPageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loopPageController = LoopPageController();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _loopPageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 150,
      child: Stack(children: [
        LoopPageView.builder(
          itemCount: _bannerList.length,
          controller: _loopPageController,
          itemBuilder: (BuildContext context, int index) => buildBannerItem(context, _bannerList[index]),
        ),
        Positioned(
            bottom: 5,
            right: 10,
            child: Container(
                width: 55,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _loopPageController.pageController,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 5,
                      dotWidth: 5,
                      expansionFactor: 3,
                      spacing: 5,
                      activeDotColor: Colors.green,
                      dotColor: Colors.white,
                    ),
                  ),
                )))
      ]),
    );
  }

  Widget buildBannerItem(BuildContext context, String path) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: Image.asset(path).image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loopPageController.dispose();
    _timer.cancel();
    super.dispose();
  }
}

class HomeCategoryTabBar extends StatefulWidget {
  final TabController tabController;
  final List<String> data;

  const HomeCategoryTabBar({super.key, required this.tabController, required this.data});

  @override
  State<StatefulWidget> createState() => _HomeCategoryTabBarState();
}

class _HomeCategoryTabBarState extends State<HomeCategoryTabBar> with SingleTickerProviderStateMixin {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Container(
      color: homeBgColor2,
      height: homeCategoryHeight2,
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Theme(
          data: themeData.copyWith(
            colorScheme: themeData.colorScheme.copyWith(
              surfaceVariant: Colors.transparent,
            ),
            indicatorColor: Colors.transparent,
          ),
          child: TabBar(
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              controller: widget.tabController,
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              tabs: widget.data.asMap().entries.map((e) {
                var index = e.key;
                var value = e.value;
                return Container(
                  height: 30,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index ? Colors.green[100] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: _selectedIndex == index ? Border.all(color: Colors.green, width: 1) : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(value),
                  ),
                );
              }).toList()),
        ),
      ),
    );
  }
}

class _AutomaticKeepAlive extends StatefulWidget {
  final Widget child;

  const _AutomaticKeepAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<_AutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<_AutomaticKeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
