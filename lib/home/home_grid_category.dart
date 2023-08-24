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
            const SizedBox(height: 5,),
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
