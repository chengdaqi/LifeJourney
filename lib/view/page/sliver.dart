import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:life_journey/component/sliver_appbar_delegate.dart';
import 'package:life_journey/utils/utils.dart';
import 'package:life_journey/view/index/model/image.dart';
import 'package:life_journey/view/index/model/image_load_view.dart';
import 'package:life_journey/view/travel/recommend_page.dart';
import 'package:life_journey/view/travel/time_line.dart';

class SliverPage extends StatefulWidget {
  SliverPage({Key key}) : super(key: key);

  @override
  createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage>
    with SingleTickerProviderStateMixin {
  List<String> titleTabs = [
    '我的旅途',
    "推荐",
    "附近",
    "旅行热点",
    "酒店民宿",
    "美食探店",
    "网红圣地",
  ];

  List<Tab> tabs = [];
  TabController controller;
  int currentIndex = 1;

  ScrollController scrollController = ScrollController();

  /// 透明度 取值范围[0,1]
  double navAlpha = 0;
  double headerHeight;
  double bannerHeight = 200;
  double viewHeight = 100;

  Brightness brightness = Brightness.dark;
  Color barIconColor = Colors.white;

  @override
  void initState() {
    super.initState();

    headerHeight = viewHeight + bannerHeight;

    scrollController.addListener(() {
      var offset = scrollController.offset;
      if (offset <= headerHeight && offset >= 0) {
        setState(() {
          navAlpha = 1 - (headerHeight - offset) / headerHeight;
          if (navAlpha > 0.5) {
            brightness = Brightness.light;
          } else {
            brightness = Brightness.dark;
          }
          barIconColor = Color.fromARGB(255, (255 - 255 * navAlpha).toInt(),
              (255 - 255 * navAlpha).toInt(), (255 - 255 * navAlpha).toInt());
        });
      }
    });

    tabs = titleTabs.map((title) => Tab(text: "$title")).toList();

    controller = TabController(
        length: titleTabs.length, vsync: this, initialIndex: currentIndex)
      ..addListener(() {
        // 监听滑动/点选位置
        if (controller.index.toDouble() == controller.animation.value) {
          setState(() => currentIndex = controller.index);
        }
      });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                        brightness: brightness,
                        floating: true,
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                        pinned: true,
                        backgroundColor: Colors.white,
                        forceElevated: innerBoxIsScrolled,
                        expandedHeight: headerHeight - Utils.topSafeHeight,
                        centerTitle: true,
                        title: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: barIconColor),
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Row(children: <Widget>[
                              Icon(Icons.search, color: Colors.grey[300]),
                              Text('关键字',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[300]))
                            ])),
                        leading: Container(
                            child:
                                Icon(Icons.home, color: barIconColor, size: 20),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20)),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.ac_unit, color: barIconColor),
                              onPressed: () {})
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(children: <Widget>[
                            /// 顶部banner部分
                            Container(
                                height: bannerHeight,
                                child: Swiper(
                                    itemBuilder: (context, index) => ImageLoadView(
                                        "https://time-with-you.oss-cn-hangzhou.aliyuncs.com/4.png"),
                                    itemCount: 4,
                                    pagination: SwiperPagination(
                                        builder: SwiperPagination.fraction,
                                        alignment: Alignment.bottomRight),
                                    autoplay: true)),

                            /// TabBar上面部分，（如果TabBar上面纵向有多个控件应尽可能多的将控件放到此处）
                            Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.red,
                                        child: Icon(Icons.home,
                                            color: Colors.white)),
                                    Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.blue,
                                        child: Icon(Icons.ac_unit_rounded,
                                            color: Colors.white)),
                                    Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.greenAccent,
                                        child: Icon(Icons.access_alarms,
                                            color: Colors.white)),
                                    Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.deepOrangeAccent,
                                        child: Icon(
                                            Icons.account_balance_wallet,
                                            color: Colors.white))
                                  ],
                                ),
                                height: 100.0,
                                color: Colors.grey[100].withOpacity(0.8))
                          ]),
                        ))),

                /// TabBar部分
                SliverPersistentHeader(
                    delegate: SliverAppBarDelegate(TabBar(
                        tabs: tabs,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        controller: controller,
                        isScrollable: true,
                        indicatorColor: Colors.yellowAccent)),
                    // 悬停到顶部
                    pinned: true)
              ];
            },
            body: TabBarView(
                controller: controller,
                children: titleTabs.map((view) {
                  return BottomGridView(title: titleTabs[currentIndex],index:currentIndex);
                }).toList())));
  }
}

class BottomGridView extends StatefulWidget {
  final int index;
  final String title;
  BottomGridView({Key key, this.index, this.title}) : super(key: key);

  @override
  createState() => BottomGridViewState();
}

class BottomGridViewState extends State<BottomGridView>
    with AutomaticKeepAliveClientMixin {
  List<ImageModal> images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<StatefulWidget> page =  [
      TimeLinePage(),
      RecommendPage(),
      RecommendPage(),
      RecommendPage(),
      RecommendPage(),
      RecommendPage(),
      RecommendPage()
    ];
    return page[widget.index];
  }

  @override
  bool get wantKeepAlive => true;
}
