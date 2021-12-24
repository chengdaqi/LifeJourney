import 'package:life_journey/http/request/base_request.dart';

class TestRequest extends BaseRequest{

  @override
  HttpRequestMethod httpRequestMethod() {
    return HttpRequestMethod.GET;
  }

  @override
  bool needLogin() {

    return false;
  }

  @override
  String path() {

    return 'uapi/test/test';
  }
}