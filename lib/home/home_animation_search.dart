import 'package:flutter/material.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/data/jd_icons.dart';
import 'package:jd_demo/home/home_auto_changed_text.dart';
import 'package:provider/provider.dart';

class HomeSearch2 extends StatefulWidget {
  const HomeSearch2({super.key});

  @override
  State<HomeSearch2> createState() => _HomeSearch2State();
}

class _HomeSearch2State extends State<HomeSearch2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Consumer<HomeSearch2Opacity>(
              builder: (context, value, child) => Opacity(opacity: value.opacity, child: child),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(
                    JdDemoIcons.orderList,
                    color: Colors.white,
                    size: 18,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -5),
                    child: Container(
                        width: 30,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            '订单',
                            style: TextStyle(color: homeHeaderBgColor2, fontSize: 10),
                          ),
                        )),
                  )
                ]),
              ),
            )),
        Consumer<HomeSearch2Opacity>(
          builder: (_, value, child) => Container(
            height: homeSearch2,
            margin: EdgeInsets.only(right: 40 * value.opacity),
            padding: const EdgeInsets.symmetric(horizontal: homeSearch2 / 2 - 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: child,
          ),
          child: Row(
            children: [
              const Expanded(
                  child:
                      AutoChangedText(data: ['键盘', '路由器', '牙刷'], style: TextStyle(color: Colors.green, fontSize: 16))),
              Container(
                width: 45,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(
                    JdDemoIcons.search,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class HomeSearch2Opacity with ChangeNotifier {
  double _opacity = 1;

  double get opacity => _opacity;

  set opacity(double value) {
    if (value == _opacity) {
      return;
    }
    _opacity = value;
    notifyListeners();
  }
}
