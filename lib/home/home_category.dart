import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/main.dart';
import 'package:provider/provider.dart';

class CategoryType {
  final String name;
  final int id;

  CategoryType(this.name, this.id);
}

class HomeCategory extends StatelessWidget {
  static List<CategoryType> dataList = [
    // 推荐、食品、酒水饮料、个护清洁、生鲜、粮油调味、家居厨具、餐厨用具、家装建材、家纺、电器、鞋靴、手机、电脑、数码、母婴、图书、玩具乐器
    CategoryType('推荐', 0),
    CategoryType('食品', 1),
    CategoryType('酒水饮料', 2),
    CategoryType('个护清洁', 3),
    CategoryType('生鲜', 4),
    CategoryType('粮油调味', 5),
    CategoryType('家居厨具', 6),
    CategoryType('餐厨用具', 7),
    CategoryType('家装建材', 8),
    CategoryType('家纺', 9),
    CategoryType('电器', 10),
    CategoryType('鞋靴', 11),
    CategoryType('手机', 12),
    CategoryType('电脑', 13),
    CategoryType('数码', 14),
  ];

  const HomeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    print('-----111');
    return Selector<HomeHeaderOpacity, double>(
      selector: (BuildContext context, HomeHeaderOpacity value) => value.opacity,
      builder: (context, opacity, child) {
        return Container(
          color: opacity == 0 ? beautyBgColor : null,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        height: homeCategoryHeight,
        color: homeHeaderBgColor1,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: _CategoryList(dataList: dataList),
            ),
            const Wrap(
              spacing: 0,
              children: [
                SizedBox(width: 6),
                Icon(JdDemoIcons.category, size: 20, color: grey1),
                Text('分类', style: TextStyle(color: grey1)),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatefulWidget {
  const _CategoryList({super.key, required this.dataList});

  final List<CategoryType> dataList;

  @override
  State createState() => _CategoryListState2();
}

class _CategoryListState2 extends State<_CategoryList> with SingleTickerProviderStateMixin {
  // late int _selectedId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _selectedId = widget.dataList[0].id;
    _tabController = TabController(length: widget.dataList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Theme(
        data: themeData.copyWith(
            colorScheme: themeData.colorScheme.copyWith(surfaceVariant: Colors.transparent),
            indicatorColor: Colors.transparent,
            primaryColor: Colors.black),
        child: TabBar(
          // onTap: (index) {
          //   print('点击了${widget.dataList[index].name}');
          //   setState(() {
          //     // _selectedId = widget.dataList[index].id;
          //   });
          // },
          isScrollable: true,
          indicatorColor: Colors.transparent,
          controller: _tabController,
          labelPadding: EdgeInsets.zero,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelColor: grey1,
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          tabs: widget.dataList.map((e) => _buildItem(e)).toList(),
        ));
  }

  Widget _buildItem(CategoryType item) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        item.name,
        // style: TextStyle(
        //     fontSize: selected ? 18 : 16,
        //     fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        //     color: selected ? Colors.black : grey1)
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// 用Listview.builder实现的横线滚动列表
class _CategoryListState1 extends State<_CategoryList> with AutomaticKeepAliveClientMixin {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print('----build-----:$_selectedIndex');
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
          onPressed: () {
            print('点击了${widget.dataList[index].name}');
            setState(() {
              _selectedIndex = index;
            });
          },
          style: TextButton.styleFrom(
              textStyle: TextStyle(
                  fontSize: _selectedIndex == index ? 18 : 16,
                  fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal),
              foregroundColor: grey1,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 2)),
          child: Text(widget.dataList[index].name),
        );
      },
    );
  }
}
