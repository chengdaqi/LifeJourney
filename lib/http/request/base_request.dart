
import 'package:life_journey/http/core/hi_cache.dart';
import 'package:life_journey/http/dao/login_dao.dart';

enum HttpRequestMethod {PUT,POST,GET,DELETE}


abstract class BaseRequest{
   // 路径中包含请求参数
   // http://api.devio.org/uapi/test/test?requestPrams=11
   var pathParams;

   var useHttps = true;

   // 返回定义的枚举类型
   HttpRequestMethod httpRequestMethod();

   String path();

   String authority() {
      return "api.devio.org";
      //console.log(q111)
   }

   // 返回全部的url地址
   String url(){
      Uri uri;
      var pathStr = path();
      if(pathParams!=null){
         if(pathStr.endsWith("/")){
            pathStr = "$pathStr$pathParams";
         }else{
            pathStr = "$pathStr/$pathParams";
         }
      }

      if(needLogin() && LoginDao.getBoardingPass()!=null){
         addHeader(LoginDao.BOARDING_PASS,LoginDao.getBoardingPass());
      }

      if(useHttps){
         // Uri.http 中第三个为 查询参数
         uri = Uri.https(authority(), pathStr,params);
         print("uri>>>>: "+"${uri.toString()}");
      }else{
         uri = Uri.http(authority(), pathStr,params);
         print("uri>>>>: "+"${uri.toString()}");
      }

      return uri.toString();
   }

   // 是否需要登录
   bool needLogin();

   // body请求参数
   Map<String,String> params = Map();

   // 构造请求体
   BaseRequest add(String k,Object v){
      params[k] = v.toString();
      return this;
   }

   Map<String ,dynamic> header = {
      'course-flag': 'fa',
      // ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa
      "auth-token": "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa",
   };
   // 构造请求头
   BaseRequest addHeader(String k,Object v){
      header[k] = v.toString();
      return this;
   }

}