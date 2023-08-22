import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/text_switch.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/demo/demo_list.dart';
import 'package:jd_demo/main.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeHeaderOpacity>(
      builder: (BuildContext context, HomeHeaderOpacity value, Widget? child) {
        return Opacity(opacity: value.opacity, child: child);
      },
      child: Container(
          color: homeHeaderBgColor,
          padding: EdgeInsets.only(top: getStatusHeight(context), left: 10, right: 10, bottom: 8),
          height: getStatusHeight(context) + homeHeader1 + homeSearch1 + 8,
          child: const Column(children: [
            SizedBox(
              height: homeHeader1,
              child: Stack(children: [
                Align(alignment: Alignment.centerLeft, child: HomeHeadSale()),
                Align(
                  alignment: Alignment.center,
                  child: TextSwitch(
                    textOn: '首页',
                    textOff: "小时达",
                    fontSize: 18,
                    height: 36,
                    textHorizontalPadding: 8,
                    // colorOn: Colors.blue,
                    // colorOff: Colors.grey,
                    // textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: HomeMessage(
                    count: 3,
                  ),
                )
              ]),

              // padding: EdgeInsets.only(top: getStatusHeight(context) + 20),
            ),
            HomeSearch(),
          ])),
    );
  }
}

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: homeSearch1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            JdDemoIcons.search,
            size: 24,
            color: Color(0xFFD64842),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
              flex: 1,
              child: Text(
                '123456',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )),
          Icon(
            JdDemoIcons.camera,
            size: 24,
            color: Color(0xFF5D5D5D),
          ),
          SizedBox(
            width: 2,
          ),
          VerticalDivider(
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Color(0xFFEEEEEE),
          ),
          SizedBox(
            width: 2,
          ),
          Icon(
            JdDemoIcons.scan,
            size: 24,
            color: Color(0xFF5D5D5D),
          ),
        ],
      ),
    );
  }
}

class HomeHeadSale extends StatelessWidget {
  final String saleStr;

  const HomeHeadSale({super.key, this.saleStr = '限时5折'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 48,
      child: Stack(
        children: [
          Positioned(
              left: 25,
              top: 14,
              child: Container(
                height: 24,
                // 设置边框阴影效果
                decoration: BoxDecoration(
                  color: const Color(0xFFFD993A),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x99FD8224),
                      offset: Offset(0, 0),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Center(
                    child: Text(
                  saleStr,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                )),
              )),
          const Image(image: AssetImage('images/jd_mask.png'), width: 36, height: 48),
        ],
      ),
    );
  }
}

class HomeMessage extends StatelessWidget {
  final int? count;

  const HomeMessage({super.key, this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoList()));
        print('-----点击了消息');
      },
      child: SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Icon(JdDemoIcons.message, color: Colors.black, size: 28),
              ),
              Visibility(
                visible: count != null && count! > 0,
                child: Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        count?.toString() ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
