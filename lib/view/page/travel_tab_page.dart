import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:life_journey/component/loading_container.dart';
import 'package:life_journey/component/webview.dart';
import 'package:life_journey/http/dao/travel_dao.dart';
import 'package:life_journey/utils/navigator_util.dart';
import 'package:life_journey/view/index/model/travel_modal.dart';


const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
const PAGE_SIZE = 10;

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final Map params;
  final String groupChannelCode;
  final int type;
  final Widget child;

  TravelTabPage(
      {Key key, this.travelUrl, this.params, this.groupChannelCode, this.type,this.child})
      : super(key: key);

  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading=true;
  Widget child;

  _TravelTabPageState({this.child}){
    this.child = child;
  }

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData({loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    try {

      TravelModel modal = await TravelDao.fetch(
          widget.travelUrl ?? TRAVEL_URL,
          widget.params,
          widget.groupChannelCode,
          widget.type,
          pageIndex,
          PAGE_SIZE);
      setState(() {
        List<TravelItem> items = _filterItems(modal.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
         _loading = false;
      });
    } catch (e) {
      print(e);
      // setState(() {
      //   _loading = false;
      // });
    }
  }

  List<TravelItem> _filterItems(List<TravelItem> items) {
    if (items == null) return null;
    List<TravelItem> filterItems = [];
    items.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  Future<Null> _handleRefresh() {
    _loadData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if(this.child!=null){
      return this.child;
    }
    return Scaffold(
      body: LodingContainer(
          isLoading: _loading,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 2,
                itemCount: travelItems?.length ?? 0,
                itemBuilder: (BuildContext context, int index) =>
                    _TravelItem(index: index, item: travelItems[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
            ),
          )),
    );
  }
}

class _TravelItem extends StatelessWidget {
  final int index;
  final TravelItem item;
  const _TravelItem({Key key, this.index, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          NavigatorUtil.push(
              context,
              WebView(
                url: item.article.urls[0].h5Url,
                hideAppBar: true,
                title: '详情',
              ));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage,
              Container(
                padding: EdgeInsets.all(4),
                child: Text(item.article.articleTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ),
              _infoText
            ],
          ),
        ),
      ),
    );
  }

  Widget get _itemImage {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get _infoText {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                    item.article.author?.coverImage?.dynamicUrl,
                    width: 24,
                    height: 24),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.thumb_up, size: 14, color: Colors.grey),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(item.article.likeCount.toString(),
                    style: TextStyle(fontSize: 10)),
              )
            ],
          )
        ],
      ),
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }
}
