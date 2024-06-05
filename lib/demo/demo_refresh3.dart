import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class TabBarViewPage2 extends StatefulWidget {
  const TabBarViewPage2({Key? key}) : super(key: key);

  @override
  TabBarViewPageState createState() {
    return TabBarViewPageState();
  }
}

class TabBarViewPageState extends State<TabBarViewPage2> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _listCount = 20;
  int _gridCount = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: EasyRefresh.builder(
        header: const ClassicHeader(
          clamping: true,
          position: IndicatorPosition.locator,
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        footer: const ClassicFooter(
          position: IndicatorPosition.locator,
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                if (_tabController.index == 0) {
                  _listCount = 20;
                } else {
                  _gridCount = 20;
                }
              });
            }
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                if (_tabController.index == 0) {
                  _listCount += 10;
                } else {
                  _gridCount += 10;
                }
              });
            }
          });
        },
        childBuilder: (context, physics) {
          return ExtendedNestedScrollView(
            floatHeaderSlivers: true,
            physics: physics,
            onlyOneScrollInBody: true,
            // pinnedHeaderSliverHeightBuilder: () {
            //   return MediaQuery.of(context).padding.top + kToolbarHeight;
            // },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                const HeaderLocator.sliver(clearExtent: false),
                SliverToBoxAdapter(
                  child: Container(
                    height: 150,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Header1',
                        style: TextStyle(color: themeData.colorScheme.primary, fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                    floating: true,
                    delegate: _HomeHeaderDelegate(
                        height: 50,
                        child: Container(
                            height: 50,
                            color: Colors.yellow,
                            child: Center(
                              child: Text(
                                'Header2',
                                style: TextStyle(color: themeData.colorScheme.primary, fontSize: 30),
                              ),
                            )))),
                SliverToBoxAdapter(
                  child: Container(
                    height: 250,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        'Header3',
                        style: TextStyle(color: themeData.colorScheme.primary, fontSize: 30),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: themeData.colorScheme.primary,
                    indicatorColor: themeData.colorScheme.primary,
                    tabs: const <Widget>[
                      Tab(
                        text: 'List',
                      ),
                      Tab(
                        text: 'Grid',
                      ),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _AutomaticKeepAlive(
                  child: CustomScrollView(
                    physics: physics,
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 100,
                          child: Text(
                            'Item:$index',
                          ),
                        );
                      }, childCount: _listCount)),
                      const FooterLocator.sliver(),
                    ],
                  ),
                ),
                _AutomaticKeepAlive(
                  child: CustomScrollView(
                    physics: physics,
                    slivers: [
                      SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 100,
                          child: Text(
                            'Item22222---:$index',
                          ),
                        );
                      }, childCount: _gridCount)),
                      const FooterLocator.sliver(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
