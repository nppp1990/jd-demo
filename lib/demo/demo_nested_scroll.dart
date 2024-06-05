import 'package:flutter/material.dart';

class NestedScrollViewDemo1 extends StatefulWidget {
  const NestedScrollViewDemo1({Key? key}) : super(key: key);

  @override
  State<NestedScrollViewDemo1> createState() {
    return _NestedScrollViewDemo1State();
  }
}

class _NestedScrollViewDemo1State extends State<NestedScrollViewDemo1> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _listCount = 50;
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
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          // onlyOneScrollInBody: true,
          // pinnedHeaderSliverHeightBuilder: () {
          //   return MediaQuery.of(context).padding.top + kToolbarHeight;
          // },
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
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
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _HomeHeaderDelegate(
                      height: 50,
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
                    )),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _AutomaticKeepAlive(
                    child: CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
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
                      ],
                    ),
                  ),
                  _AutomaticKeepAlive(
                    child: CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
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
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
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

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _HomeHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print('----build----shrinkOffset:$shrinkOffset,overlapsContent:$overlapsContent');
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
