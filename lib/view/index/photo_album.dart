import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:life_journey/utils/utils.dart';
import 'model/album.dart';
import 'model/image_load_view.dart';

List<Album> photoAlbums = [
  Album(
      picUrl:
          'https://time-with-you.oss-cn-hangzhou.aliyuncs.com/1.png',
      name: '亲子日记'),
  Album(
      picUrl:
          'https://time-with-you.oss-cn-hangzhou.aliyuncs.com/2.png',
      name: '我的故事'),
  Album(
      picUrl:
          'https://time-with-you.oss-cn-hangzhou.aliyuncs.com/3.png',
      name: '旅行日记'),
  Album(
      picUrl:
          'https://time-with-you.oss-cn-hangzhou.aliyuncs.com/4.png',
      name: '致青春'),
];

class photoAlbum extends StatefulWidget {
  @override
  createState() => _MoviesConceptPageState();
}

class _MoviesConceptPageState extends State<photoAlbum> {
  final pageController = PageController(viewportFraction: .8);
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);

  void _listener() {
    _pageNotifier.value = pageController.page;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.addListener(_listener);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.removeListener(_listener);
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
            child: ValueListenableBuilder<double>(
                valueListenable: _pageNotifier,
                builder: (context, value, child) {
                  return Stack(
                      children: photoAlbums.reversed
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) => Positioned.fill(
                              child: ClipRect(
                                  clipper: MyClipper(
                                      percentage: value,
                                      title: entry.value.name,
                                      index: entry.key),
                                  child: ImageLoadView(entry.value.picUrl))))
                          .toList());
                })),
        PageView.builder(
            itemCount: photoAlbums.length,
            controller: pageController, // 切换
            itemBuilder: (context, index) {
              final lerp =
                  lerpDouble(0, 1, (index - _pageNotifier.value).abs());

              double opacity =
                  lerpDouble(0.0, .5, (index - _pageNotifier.value).abs());
              if (opacity > 1.0) opacity = 1.0;
              if (opacity < 0.0) opacity = 0.0;
              return Transform.translate(
                  offset: Offset(0.0, lerp * 50),
                  child: Opacity(
                      opacity: (1 - opacity),
                      child: Align(
                          alignment: Alignment.center,
                          child: Card(
                              color: Colors.white,
                              borderOnForeground: true,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: borderRadius),
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                  height: Utils.height / 1.5,
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(children: [
                                    Expanded(
                                        child: ClipRRect(
                                            borderRadius: borderRadius,
                                            child: ImageLoadView(
                                                photoAlbums[index].picUrl))),
                                    SizedBox(height: 15),
                                    Text(photoAlbums[index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 24)),
                                    RaisedButton(
                                        color: Colors.black,
                                        child: Text('点击回忆',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {})
                                  ]))))));
            }),
      ]),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  final double percentage;
  final String title;
  final int index;

  MyClipper({this.percentage = 0.0, this.title, this.index});

  @override
  Rect getClip(Size size) {
    int currentIndex = photoAlbums.length - 1 - index;
    final realPercent = (currentIndex - percentage).abs();
    if (currentIndex == percentage.truncate()) {
      return Rect.fromLTWH(
          0.0, 0.0, size.width * (1 - realPercent), size.height);
    }
    if (percentage.truncate() > currentIndex) {
      return Rect.fromLTWH(0.0, 0.0, 0.0, size.height);
    }
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
