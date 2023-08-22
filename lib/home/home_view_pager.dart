import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageIndicator(
        height: 300,
        width: double.infinity,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.yellow,
            child: Center(
              child: Text(index.toString()),
            ),
          );
        });
  }
}

class PageIndicator extends StatefulWidget {
  final double height;
  final double width;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  const PageIndicator(
      {super.key, required this.height, required this.width, required this.itemCount, required this.itemBuilder});

  @override
  State<StatefulWidget> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  int _indicatorIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _indicatorIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _indicatorIndex = index;
              });
            },
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
          ),
        ),
        Positioned(
          bottom: 20,
          child: Container(
              height: 22,
              width: 100,
              alignment: Alignment.center,
              child: CommonIndicator(
                itemCount: widget.itemCount,
                current: _indicatorIndex,
                onTap: (index) {
                  if (_indicatorIndex != index) {
                    _pageController.jumpToPage(index);
                    setState(() {
                      _indicatorIndex = index;
                    });
                  }
                },
              )),
        )
      ],
    );
  }
}

class CommonIndicator extends StatelessWidget {
  final int itemCount;
  final int current;
  final ValueChanged<int>? onTap;

  const CommonIndicator({super.key, required this.itemCount, required this.current, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onTap?.call(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: CircleAvatar(
              radius: 5,
              backgroundColor: current == index ? Colors.white : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
