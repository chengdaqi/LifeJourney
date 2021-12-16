
import 'package:life_journey/http/request/base_request.dart';

/// 注册请求
class RegisterRequest extends BaseRequest{
  @override
  HttpRequestMethod httpRequestMethod() {
    return HttpRequestMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "/uapi/user/registration";
  }

}