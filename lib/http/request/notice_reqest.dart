import 'base_request.dart';

class NoticeRequest extends BaseRequest {

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return '/uapi/notice';
  }

  @override
  HttpRequestMethod httpRequestMethod() {
    return HttpRequestMethod.GET;
  }
}