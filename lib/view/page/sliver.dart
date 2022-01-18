import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:life_journey/component/sliver_appbar_delegate.dart';
import 'package:life_journey/utils/utils.dart';
import 'package:life_journey/view/index/model/image.dart';
import 'package:life_journey/view/index/model/image_load_view.dart';
import 'package:life_journey/view/page/time_line.dart';

/**
 *
 *
 * **/
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
  double viewHeight = 200;

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
    List listData = [
      {
        "title": "标题1",
        "author": "内容1",
        "image": "https://www.itying.com/images/flutter/1.png"
      },
      {
        "title": "标题2",
        "author": "内容2",
        "image": "https://www.itying.com/images/flutter/2.png"
      },
      {
        "title": "标题3",
        "author": "内容3",
        "image": "https://www.itying.com/images/flutter/3.png"
      },
      {
        "title": "标题4",
        "author": "内容4",
        "image": "https://www.itying.com/images/flutter/4.png"
      },
      {
        "title": "标题5",
        "author": "内容5",
        "image": "https://www.itying.com/images/flutter/5.png"
      },
      {
        "title": "标题6",
        "author": "内容6",
        "image": "https://www.itying.com/images/flutter/6.png"
      },
      {
        "title": "标题7",
        "author": "内容7",
        "image": "https://www.itying.com/images/flutter/7.png"
      },
      {
        "title": "标题8",
        "author": "内容8",
        "image": "https://www.itying.com/images/flutter/1.png"
      },
      {
        "title": "标题9",
        "author": "内容9",
        "image": "https://www.itying.com/images/flutter/2.png"
      }
    ];

    List<Widget> _getData() {
      List<Widget> list = new List();
      for (var i = 0; i < listData.length; i++) {
        list.add(Container(
          child: ListView(
            children: [
              Image.network(
                listData[i]["image"],
                fit: BoxFit.cover,
              ),
              Text(
                listData[i]["title"],
                textAlign: TextAlign.center,
              )
            ],
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1)),
        ));
      }
      return list;
    }

    // Tab 页面
    List<StatefulWidget> page = [
      TimeLinePage(),
      TimeLinePage(),
      TimeLinePage(),
      TimeLinePage(),
      TimeLinePage(),
      TimeLinePage(),
      TimeLinePage()
    ];

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
                        automaticallyImplyLeading: false,
                        elevation: 0.0,
                        pinned: true,
                        backgroundColor: Colors.deepPurpleAccent,
                        forceElevated: innerBoxIsScrolled,
                        // expandedHeight: headerHeight - Utils.topSafeHeight,
                        expandedHeight: 0,
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
                            // TODO 替换logo
                            child: Icon(Icons.account_balance,
                                color: barIconColor, size: 20),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20)),
                        actions: <Widget>[
                          IconButton(
                              icon:
                                  Icon(Icons.eco_rounded, color: barIconColor),
                              onPressed: () {})
                        ],
                        /*flexibleSpace: FlexibleSpaceBar(
                          background: Column(children: <Widget>[
                            /// 顶部banner部分
                            Container(
                                height: 200,
                                child: Swiper(
                                    itemBuilder: (context, index) => ImageLoadView(
                                        ''),
                                    itemCount: 4,
                                    pagination: SwiperPagination(
                                        builder: SwiperPagination.fraction,
                                        alignment: Alignment.bottomRight),
                                    autoplay: true)),
                            Container(
                                //padding: EdgeInsets.all(0),
                                alignment: Alignment.topCenter,
                                child: GridView.count(
                                    crossAxisCount: 4,
                                    //padding: EdgeInsets.all(10),
                                    crossAxisSpacing: 5,
                                    shrinkWrap: true,
                                    //mainAxisSpacing: 10,
                                    children: _getData()),
                                height: 100.0,
                                color: Colors.grey[300].withOpacity(0.8)),
                          ]),
                        )*/
                    )
                ),

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
                  //return BottomGridView(title: titleTabs[currentIndex]);
                  // return TimeLinePage();
                  return page[currentIndex];
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
    getListData(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double itemWidth = Utils.width / 2 - 4;

    return images.isEmpty
        ? Center()
        : StaggeredGridView.countBuilder(
            padding: EdgeInsets.only(top: Utils.navigationBarHeight),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemBuilder: (context, index) => ImageLoadView(
                  images[index].thumb,
                  width: itemWidth,
                  height:
                      itemWidth * images[index].height / images[index].width,
                ),
            staggeredTileBuilder: (index) => StaggeredTile.fit(3),
            itemCount: images.length);
  }

  void getListData(String key) async {
    images = [];
    // images = await OtherRepository.getImagesData(key);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;
}
