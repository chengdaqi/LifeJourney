import 'package:flutter/material.dart';
import 'package:life_journey/http/dao/travel_tab_dao.dart';

import 'package:life_journey/view/index/model/travel_tab_modal.dart';

import 'travel_tab_page.dart';

// 旅拍页面
class TravelPage extends StatefulWidget {
  TravelPage({Key key}) : super(key: key);

  _TravelPageState createState() => _TravelPageState();
}
// TickerProviderStateMixin
class _TravelPageState extends State<TravelPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<TravelTab> tabs = [];
  TravelTabModal travelTabModal;

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 加载数据
  void _loadData() async {
    _tabController = TabController(length: 0, vsync: this);
    try {
      TravelTabModal modal = await TravelTabModalDao.fetch();
      _tabController = TabController(length: modal.tabs.length, vsync: this);
      setState(() {
        tabs = modal.tabs;
        travelTabModal = modal;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = tabs.map((TravelTab tab){
      return TravelTabPage(
        travelUrl: travelTabModal.url,
        params: travelTabModal.params,
        groupChannelCode: tab.groupChannelCode,
        type: tab.type,
      );
    }).toList();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Color(0xff1fcfbb),
                  width: 3
                ),
                insets: EdgeInsets.only(bottom: 10),
              ),
              tabs: tabs.map((TravelTab tab){
                return Tab(text:tab.labelName);
              }).toList(),
            ),
          ),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: list
            ),
          )
        ],
      ),
    );
  }
}
