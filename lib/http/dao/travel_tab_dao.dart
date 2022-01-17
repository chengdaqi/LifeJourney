
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:life_journey/view/index/model/travel_tab_modal.dart';

const TRAVEL_TAB_URL =
    'https://apk-1256738511.file.myqcloud.com/FlutterTrip/data/travel_page.json';
// 旅拍类别接口
class TravelTabModalDao{
  static Future<TravelTabModal> fetch() async{
   Response response=await new Dio().get(TRAVEL_TAB_URL);
    if(response.statusCode == 200){
      return TravelTabModal.fromJson(response.data);
    }else{
       throw Exception('Failed to load travel_page.json');
    }
  }
}