import 'package:flutter/material.dart';
import 'package:life_journey/http/core/hi_cache.dart';
import 'package:life_journey/http/core/hi_net.dart';
import 'package:life_journey/http/request/base_request.dart';
import 'package:life_journey/http/request/login_request.dart';
import 'package:life_journey/http/request/register_request.dart';

class LoginDao {

   static String BOARDING_PASS = "boarding-pass";

  static login(String username, String password) {
    return _send(username, password);
  }

  static register(
      String username, String password, String imoocId, String orderId) {
    return _send(username, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String username, String password,
      {String imoocId, String orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegisterRequest();
      
      request.addHeader("imoocId", imoocId);
      request.addHeader("orderId", orderId);
    } else {
      request = LoginRequest();
    }

    request
        .add("userName", username)
        .add("password", password);

    // 设置请求头
    /*request.addHeader("auth-token", "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa");
    request.addHeader("course-flag", "fa");*/
    var result = await HiNet.getInstance().fire(request);

    print(result);
    if(result['code'] == 0 && result['data']!=null){
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
  }

  // 需要登录后成功后才有值
  static getBoardingPass(){
    var cachePass = HiCache.getInstance().get(BOARDING_PASS);
    if(cachePass==null){
      print("token为空，请先登录");
      return null;
    }else{
      return cachePass;
    }
  }

}
