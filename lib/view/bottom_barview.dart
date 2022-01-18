import 'package:flutter/material.dart';
import 'package:life_journey/view/page/bottom_bar_view.dart';
import 'package:life_journey/view/index/photo_album.dart';
import 'package:life_journey/view/index/travel_diary.dart';

import 'index/future_self.dart';
import 'index/myself.dart';

class BottomBarViewDemo extends StatefulWidget {
  BottomBarViewDemo({Key key}) : super(key: key);

  @override
  createState() => _BottomBarViewDemoState();
}

class _BottomBarViewDemoState extends State<BottomBarViewDemo> {
  final List<Widget> page = List();
  int _currentIndex = 0;

  @override
  void initState() {
    page.add(PhotoAlbum());
    page.add(TravelDiary());
    page.add(FutureSelf());
    page.add(Myself());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("陪你的时光"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
      ),*/
      body: Stack(
        children: <Widget>[
          Container(child: (page == null ? PhotoAlbum() : page[_currentIndex])),
          bottomBar(),
        ],
      ),
    );
  }

  Widget bottomBar() {
    return Column(children: <Widget>[
      Expanded(child: SizedBox()),
      BottomBarView(
        tabIconsList: tabIconsList,
        addClick: () {},
        changeIndex: (index) => setState(() => _currentIndex = index),
      )
    ]);
  }

  static List<TabIconData> tabIconsList = [
    TabIconData(
        icon: Image.asset('images/tag_icons/tab_1.png'),
        selectedIcon: Image.asset('images/tag_icons/tab_1s.png'),
        index: 0,
        isSelected: true,
        animationController: null),
    TabIconData(
        icon: Image.asset('images/tag_icons/tab_2.png'),
        selectedIcon: Image.asset('images/tag_icons/tab_2s.png'),
        index: 1,
        isSelected: false,
        animationController: null),
    TabIconData(
        icon: Image.asset('images/tag_icons/tab_3.png'),
        selectedIcon: Image.asset('images/tag_icons/tab_3s.png'),
        index: 2,
        isSelected: false,
        animationController: null),
    TabIconData(
        icon: Image.asset('images/tag_icons/tab_4.png'),
        selectedIcon: Image.asset('images/tag_icons/tab_4s.png'),
        index: 3,
        isSelected: false,
        animationController: null)
  ];
}
