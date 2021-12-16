import 'package:life_journey/http/request/base_request.dart';

/// 登录请求
class LoginRequest extends BaseRequest {
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
    return "uapi/user/login";
  }
}
