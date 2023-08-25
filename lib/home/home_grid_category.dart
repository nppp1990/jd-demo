import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/shiny_text.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GirdCateGoryInfo {
  final String imgUrl;
  final String title;
  List<String>? mask;

  GirdCateGoryInfo(this.imgUrl, this.title, {this.mask});
}

class HomeGirdCategory extends StatefulWidget {
  const HomeGirdCategory({super.key});

  @override
  State<StatefulWidget> createState() => _HomeGirdCategoryState();
}

class _HomeGirdCategoryState extends State<HomeGirdCategory> {
  static const double itemHeight = 75.0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // 一行5个 w/h=childAspectRatio
    double childAspectRatio = getScreenWidth(context) / (5 * itemHeight);
    return Stack(children: [
      Column(
        children: [
          Container(
            height: 10,
            color: beautyBgColor,
            child: Container(
              decoration: const BoxDecoration(
                color: white2,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: itemHeight * 2,
            child: PageView(
              controller: _pageController,
              children: [
                _buildGrid(childAspectRatio, [
                  GirdCateGoryInfo('images/avatar1.jpeg', '京东超市'),
                  GirdCateGoryInfo('images/avatar1.jpeg', '数码电器'),
                  GirdCateGoryInfo('images/avatar1.jpeg', '京东买药', mask: ['买药', '1分']),
                  GirdCateGoryInfo('images/avatar1.jpeg', '京东生鲜'),
                  GirdCateGoryInfo('images/avatar1.jpeg', '京东到家'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '充值缴费', mask: ['充值', '缴费', '电费']),
                  GirdCateGoryInfo('images/avatar2.jpeg', '9.9元拼'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '领券'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '赚钱'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '全部'),
                ]),
                _buildGrid(childAspectRatio, [
                  GirdCateGoryInfo('images/avatar2.jpeg', '京东国际'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '京东拍卖'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '京东生鲜'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '京东到家'),
                  GirdCateGoryInfo('images/avatar2.jpeg', '买车养车'),
                  GirdCateGoryInfo('images/avatar1.jpeg', 'test1'),
                  GirdCateGoryInfo('images/avatar1.jpeg', 'test2'),
                  GirdCateGoryInfo('images/avatar1.jpeg', 'test3'),
                  GirdCateGoryInfo('images/avatar1.jpeg', '更多频道'),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
      Positioned(
        bottom: 6,
        left: 0,
        right: 0,
        child: Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: const ExpandingDotsEffect(
              dotHeight: 5,
              dotWidth: 5,
              expansionFactor: 3,
              spacing: 5,
              activeDotColor: Colors.red,
              dotColor: grey4,
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildGrid(double childAspectRatio, List<GirdCateGoryInfo> list) {
    return GridView.count(
      padding: EdgeInsets.zero,
      childAspectRatio: childAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 5,
      children: list.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem(GirdCateGoryInfo info) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 5,
            ),
            Image.asset(
              info.imgUrl,
              width: 45,
              height: 45,
              fit: BoxFit.fill,
            ),
            // const SizedBox(height: 5),
            Text(
              info.title,
              style: const TextStyle(color: grey3),
            ),
          ],
        ),
        if (info.mask != null)
          Positioned(
            top: 0,
            right: 5,
            child: AutoShinyText(
              data: info.mask!,
              width: 35,
              height: 16,
              textStyle: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class HomeGridCategory2 extends StatefulWidget {
  final double width;
  final List<GirdCateGoryInfo> data;

  const HomeGridCategory2({super.key, required this.width, required this.data});

  @override
  State<HomeGridCategory2> createState() => _HomeGridCategory2State();
}

class _HomeGridCategory2State extends State<HomeGridCategory2> {
  static const double defaultImgSize = 45;
  static const double itemHeight = 80;
  late PageController _pageController;
  late int _pageCount;
  late ValueNotifier<double> _heightRatioNotifier;

  @override
  void initState() {
    super.initState();
    _pageCount = 0;
    int size = 0;
    while (size < widget.data.length) {
      _pageCount++;
      size += 5 * _pageCount;
    }
    _pageController = PageController()
      ..addListener(() {
        _heightRatioNotifier.value = 1 + _pageController.page!;
      });
    _heightRatioNotifier = ValueNotifier(1.0);
  }

  @override
  Widget build(BuildContext context) {
    double childAspectRatio = widget.width / (5 * itemHeight);
    return ValueListenableBuilder<double>(
      valueListenable: _heightRatioNotifier,
      builder: (BuildContext context, value, Widget? child) => SizedBox(
        height: itemHeight * value,
        child: child,
      ),
      child: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: _pageCount,
              itemBuilder: (context, index) {
                // f(0)=0 f(n+1)=f(n)+ 5*n
                // f(n) = 5*n*(n+1)/2
                int start = 5 * index * (index + 1) ~/ 2;
                int end = start + (index + 1) * 5;
                end = min(end, widget.data.length);
                return _buildGrid(childAspectRatio, widget.data.sublist(start, end));
              }),
          Positioned(
            bottom: 2,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pageCount,
                effect: const ExpandingDotsEffect(
                  dotHeight: 5,
                  dotWidth: 5,
                  expansionFactor: 3,
                  spacing: 5,
                  activeDotColor: Colors.red,
                  dotColor: grey4,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildGrid(double childAspectRatio, List<GirdCateGoryInfo> list) {
    return GridView.count(
      padding: EdgeInsets.zero,
      childAspectRatio: childAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 5,
      children: list.map((e) => _buildItem(e, defaultImgSize)).toList(),
    );
  }

  Widget _buildItem(GirdCateGoryInfo info, double imgSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 5,
        ),
        CircleAvatar(
          radius: imgSize / 2,
          backgroundImage: AssetImage(
            info.imgUrl,
          ),
        ),
        SizedBox(
          height: 20,
          child: Center(
            child: Text(
              info.title,
              style: const TextStyle(color: grey3, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeGridCategoryLayout2 extends StatelessWidget {
  const HomeGridCategoryLayout2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          _buildHeader('1小时送到家', '生鲜百货，随叫随到'),
          HomeGridCategory2(width: getScreenWidth(context) - 20, data: [
            GirdCateGoryInfo('images/avatar1.jpeg', '超市便利'),
            GirdCateGoryInfo('images/avatar1.jpeg', '手机'),
            GirdCateGoryInfo('images/avatar1.jpeg', '买菜'),
            GirdCateGoryInfo('images/avatar1.jpeg', '时尚百货'),
            GirdCateGoryInfo('images/avatar1.jpeg', '买药'),
            GirdCateGoryInfo('images/avatar2.jpeg', '蛋糕甜点'),
            GirdCateGoryInfo('images/avatar2.jpeg', '电脑数码'),
            GirdCateGoryInfo('images/avatar2.jpeg', '母婴'),
            GirdCateGoryInfo('images/avatar2.jpeg', '酒水'),
            GirdCateGoryInfo('images/avatar2.jpeg', '水果'),
            GirdCateGoryInfo('images/avatar2.jpeg', '鲜花绿植'),
            GirdCateGoryInfo('images/avatar2.jpeg', '宠物生活'),
          ]),
          _buildHeader('同城服务', '吃喝玩乐，应有尽有'),
          HomeGridCategory2(width: getScreenWidth(context) - 20, data: [
            GirdCateGoryInfo('images/avatar2.jpeg', '美食'),
            GirdCateGoryInfo('images/avatar2.jpeg', '家政服务'),
            GirdCateGoryInfo('images/avatar2.jpeg', '生活缴费'),
            GirdCateGoryInfo('images/avatar2.jpeg', '电影演出'),
            GirdCateGoryInfo('images/avatar2.jpeg', '摄影写真'),
            GirdCateGoryInfo('images/avatar1.jpeg', '家装定制'),
            GirdCateGoryInfo('images/avatar1.jpeg', '丽人/美发'),
            GirdCateGoryInfo('images/avatar1.jpeg', '结婚/婚纱'),
            GirdCateGoryInfo('images/avatar1.jpeg', '教育培训'),
            GirdCateGoryInfo('images/avatar1.jpeg', '医疗健康'),
            GirdCateGoryInfo('images/avatar1.jpeg', '运动健身'),
            GirdCateGoryInfo('images/avatar1.jpeg', '亲子/幼教'),
            GirdCateGoryInfo('images/avatar1.jpeg', '家居维修'),
          ]),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, String subTitle) {
    return SizedBox(
      height: 30,
      child: Row(children: [
        const SizedBox(
          width: 10,
        ),
        Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(subTitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ]),
    );
  }
}
