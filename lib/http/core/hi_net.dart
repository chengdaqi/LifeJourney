import 'package:life_journey/http/request/base_request.dart';

class HiNet {
  // 构造器
  HiNet();

  static HiNet _instance;

  // 单例
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = new HiNet();
    }
    return _instance;
  }

  Future<dynamic> send<T>(BaseRequest request) async{
    print("url:${request.url()}");
    print("method:${request.httpRequestMethod()}");
    request.addHeader("token", "123");
    print("header:${request.header}");
    // mock 请求的返回值
    return Future.value({
      "statusCode":200,
      "data":{"code":0,"message":"success"}
    });
  }

  Future fire(BaseRequest request) async{
    var response = await send(request);
    var result = response["data"];
    print("result+${result.toString()}");
    return result;
  }
}
