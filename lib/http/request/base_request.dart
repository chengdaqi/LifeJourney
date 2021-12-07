
enum HttpRequestMethod {PUT,POST,GET,DELETE}


abstract class BaseRequest{
   // 路径中包含请求参数
   // http://api.devio.org/uapi/test/test?requestPrams=11
   var pathParams;

   var useHttps = false;

   // 默认前缀
   static final authority = "api.devio.org";

   // 返回定义的枚举类型
   HttpRequestMethod httpRequestMethod();

   String path();

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
      if(useHttps){
         uri = Uri.https(authority, pathStr,pathParams);
      }else{
         uri = Uri.http(authority, pathStr,pathParams);
      }
      print("uri"+"${uri.toString()}");
      return uri.toString();
   }

   // 是否需要登录
   bool needLogin();

   // 请求参数
   Map<String,String> params = Map();

   // 构造请求体
   BaseRequest add(String k,Object v){
      params[k] = v.toString();
      return this;
   }

   Map<String ,dynamic> header = {};
   // 构造请求头
   BaseRequest addHeader(String k,Object v){
      header[k] = v.toString();
      return this;
   }

}