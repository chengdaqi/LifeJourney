import 'package:life_journey/http/request/base_request.dart';

class TestRequest extends BaseRequest{

  @override
  HttpRequestMethod httpRequestMethod() {
    return HttpRequestMethod.GET;
  }
//测试测试·
  @override
  bool needLogin() {

    return false;
  }
//测试测试·
  @override
  String path() {

    return 'uapi/test/test';
  }
}