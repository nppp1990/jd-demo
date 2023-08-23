import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class PageIndicatorDemo extends StatefulWidget {
  const PageIndicatorDemo({super.key});

  @override
  State<PageIndicatorDemo> createState() => _PageIndicatorDemoState();
}

class _PageIndicatorDemoState extends State<PageIndicatorDemo> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
        6,
            (index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Container(
            height: 280,
            child: Center(
                child: Text(
                  "Page $index",
                  style: const TextStyle(color: Colors.indigo),
                )),
          ),
        ));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 12),
                child: Text(
                  'Worm',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  type: WormType.thinUnderground,
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 12),
                child: Text(
                  'Expanding Dots',
                  style: TextStyle(color: Colors.black54),
                ),
              ),

              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 16,
                  dotWidth: 16,
                  expansionFactor: 4,
                  spacing: 8,
                  activeDotColor: Colors.indigo,
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 12),
                child: Text(
                  'SlideEffect',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const SlideEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 24.0,
                  dotHeight: 16.0,
                  dotColor: Colors.grey,
                  paintStyle: PaintingStyle.stroke,
                  strokeWidth: 1.5,
                  activeDotColor: Colors.indigo,
                ),
              ),



              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Jumping Dot',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: pages.length,
                  effect: const JumpingDotEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    jumpScale: .7,
                    verticalOffset: 15,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 12),
                child: Text(
                  'Scrolling Dots',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SmoothPageIndicator(
                  controller: controller,
                  count: pages.length,
                  effect: const ScrollingDotsEffect(
                    activeStrokeWidth: 2.6,
                    activeDotScale: 1.3,
                    maxVisibleDots: 5,
                    radius: 8,
                    spacing: 10,
                    dotHeight: 12,
                    dotWidth: 12,
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  'Customizable Effect',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Container(
                // color: Colors.red.withOpacity(.4),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: pages.length,
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 32,
                      height: 12,
                      color: Colors.indigo,
                      rotationAngle: 180,
                      verticalOffset: -10,
                      borderRadius: BorderRadius.circular(24),
                      dotBorder: DotBorder(
                        padding: 2,
                        width: 2,
                        color: Colors.indigo,
                      ),
                    ),
                    dotDecoration: DotDecoration(
                      width: 24,
                      height: 12,
                      color: Colors.grey,
                      // dotBorder: DotBorder(
                      //   padding: 2,
                      //   width: 2,
                      //   color: Colors.grey,
                      // ),
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(2),
                      //     topRight: Radius.circular(16),
                      //     bottomLeft: Radius.circular(16),
                      //     bottomRight: Radius.circular(2)),
                      borderRadius: BorderRadius.circular(16),
                      verticalOffset: 0,
                    ),
                    spacing: 6.0,
                    // activeColorOverride: (i) => colors[i],
                    inActiveColorOverride: (i) => colors[i],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

const colors = [
  Colors.red,
  Colors.green,
  Colors.greenAccent,
  Colors.amberAccent,
  Colors.blue,
  Colors.amber,
];