import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jd_demo/api/bean/home_page_info.dart';
import 'package:jd_demo/api/request_manager.dart';
import 'package:jd_demo/common/constant.dart';
import 'package:jd_demo/common/platform.dart';
import 'package:jd_demo/common/ui_utils.dart';
import 'package:jd_demo/home/home_animation_search.dart';
import 'package:jd_demo/home/refresh1.dart';
import 'package:jd_demo/home/refresh2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:jd_demo/home/home_header.dart';
import 'package:provider/provider.dart';

void main() {
  // if (PlatformUtils.instance.isMobile && Platform.isAndroid) {
  if (PlatformUtils.instance.isMobile && Platform.isAndroid) {
    setOverlayStyleInAndroid();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<HomePageInfoResult?>(
            create: (context) => RequestManager.instance.getHomePageInfo(),
            initialData: HomePageInfoResult.fromJson({}))
      ],
      child: RefreshConfiguration(
        footerTriggerDistance: 15,
        dragSpeedRatio: 0.91,
        headerBuilder: () => const MaterialClassicHeader(),
        footerBuilder: () => const ClassicFooter(),
        enableLoadingWhenNoData: false,
        enableRefreshVibrate: false,
        enableLoadMoreVibrate: false,
        shouldFooterFollowWhenNotFull: (state) {
          // If you want load more with noMoreData state ,may be you should return false
          return false;
        },
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Scaffold(
            backgroundColor: white2,
            body: TestHome(),
          ),
        ),
      ),
    );
  }
}

class HomeHeaderOpacity with ChangeNotifier {
  double opacity = 1.0;
  bool showBackgroundHead = false;

  void changeOpacity(double newValue) {
    if (newValue == opacity) {
      return;
    }
    opacity = newValue;
    notifyListeners();
  }

  void changeShowBackgroundHead(bool newValue) {
    if (newValue == showBackgroundHead) {
      return;
    }
    showBackgroundHead = newValue;
    notifyListeners();
  }
}

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<StatefulWidget> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  late PageController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeHeaderOpacity>(create: (ctx) => HomeHeaderOpacity()),
        ChangeNotifierProvider<HomeSearch2Opacity>(create: (ctx) => HomeSearch2Opacity())
      ],
      child: Stack(
        children: [
          Selector<HomeHeaderOpacity, bool>(
            selector: (ctx, provider) => provider.showBackgroundHead,
            builder: (ctx, showBackgroundHead, child) {
              return Offstage(
                  offstage: !showBackgroundHead,
                  child: const TestBottom(
                    paddingBottom: homeCategoryHeight,
                  ));
            },
          ),
          PageView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeRefreshPage1(),
              HomeRefreshPage2(),
            ],
          ),
          HomeHeader(onChanged: (value) {
            _tabController.jumpToPage(value ? 0 : 1);
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
