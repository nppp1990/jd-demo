import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/text_switch.dart';
import 'package:jd_demo/common/utils/screen_util.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/demo/demo_list.dart';
import 'package:jd_demo/main.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  ValueChanged<bool>? onChanged;

  HomeHeader({super.key, this.onChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late ValueNotifier<bool> _isOnNotifier;

  @override
  void initState() {
    super.initState();
    _isOnNotifier = ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeHeaderOpacity>(
      builder: (BuildContext context, HomeHeaderOpacity value, Widget? child) {
        return Opacity(opacity: value.opacity, child: child);
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isOnNotifier,
        builder: (context, isOn, child) {
          return Container(
            color: isOn ? homeHeaderBgColor1 : homeHeaderBgColor2,
            padding: EdgeInsets.only(top: getStatusHeight(context), left: 10, right: 10, bottom: isOn ? 8 : 0),
            child: child,
          );
        },
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: homeHeader1,
            child: Stack(children: [
              const Align(alignment: Alignment.centerLeft, child: HomeHeadSale()),
              Align(
                alignment: Alignment.center,
                child: TextSwitch(
                  textOn: '首页',
                  textOff: "小时达",
                  fontSize: 18,
                  height: 36,
                  textHorizontalPadding: 8,
                  onChanged: (value) {
                    _isOnNotifier.value = value;
                    widget?.onChanged?.call(value);
                  },
                  // colorOn: Colors.blue,
                  // colorOff: Colors.grey,
                  // textStyle: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: HomeMessage(
                  count: 3,
                ),
              )
            ]),

            // padding: EdgeInsets.only(top: getStatusHeight(context) + 20),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isOnNotifier,
            builder: (_, isOn, child) => Visibility(visible: isOn, child: child!),
            child: const HomeSearch(),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _isOnNotifier.dispose();
    super.dispose();
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
              child: _AutoChangedText(
                data: ['dior口红礼盒', '修甲套装', '王国之泪', 'Switch', '七夕节好礼'],
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

class _AutoChangedText extends StatefulWidget {
  final List<String> data;

  const _AutoChangedText({super.key, required this.data});

  @override
  State<_AutoChangedText> createState() => _AutoChangedTextState();
}

class _AutoChangedTextState extends State<_AutoChangedText> {
  late Timer _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _index++;
        _index = _index % widget.data.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data[_index],
      style: const TextStyle(fontSize: 18, color: Colors.grey),
    );
  }
}

class HomeHeadSale extends StatelessWidget {
  final String saleStr;

  const HomeHeadSale({super.key, this.saleStr = '限时5折'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 48,
      child: Stack(
        children: [
          Positioned(
              left: 25,
              top: 14,
              child: Container(
                  height: 24,
                  width: 85,
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
                  padding: const EdgeInsets.only(left: 5),
                  child: const _AutoLoopTextPager(
                    height: 24,
                    data: ['跨店满减', '300减30', 'saber最帅'],
                  ))),
          const Image(image: AssetImage('images/jd_mask.png'), width: 36, height: 48),
        ],
      ),
    );
  }
}

class _AutoLoopTextPager extends StatefulWidget {
  final List<String> data;
  final double height;

  const _AutoLoopTextPager({super.key, required this.data, required this.height});

  @override
  State<_AutoLoopTextPager> createState() => _AutoLoopTextPagerState();
}

class _AutoLoopTextPagerState extends State<_AutoLoopTextPager> {
  late LoopPageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = LoopPageController();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoopPageView.builder(
      scrollDirection: Axis.vertical,
      controller: _pageController,
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: widget.height,
          child: Center(
            child: Text(widget.data[index],
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        );
      },
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
