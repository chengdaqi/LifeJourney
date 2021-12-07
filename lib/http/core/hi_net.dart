import 'package:life_journey/http/core/hi_net_exception.dart';
import 'package:life_journey/http/request/base_request.dart';
import 'package:life_journey/http/test/mock_adapter.dart';

import 'hi_net_adapater.dart';

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

  Future<dynamic> send<T>(BaseRequest request) async {
    HiNetAdapter adapter = MockAdapter();
    return adapter.send(request);
  }

  Future fire(BaseRequest request) async {
    HiNetResponse response;
    var error;

    try {
      response = await send(request);
    } on HiNetException catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;

    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetException(status ?? -1, result.toString(), data: result);
    }
  }

  void printLog(log) {
    print('hi_net:' + log.toString());
  }
}
