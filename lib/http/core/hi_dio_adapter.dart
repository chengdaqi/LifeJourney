import 'package:dio/dio.dart';
import 'package:life_journey/http/core/hi_net_exception.dart';
import 'package:life_journey/http/request/base_request.dart';

import 'hi_net_adapater.dart';

// Dio网络适配器 主要完成请求的方法
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response, error;
    var options = Options(headers: request.header);
    try {
      if (request.httpRequestMethod() == HttpRequestMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      }
      else if (request.httpRequestMethod() == HttpRequestMethod.POST) {
        response = await Dio().post(request.url(),
            data: request.params, options: options);
      }

      else if (request.httpRequestMethod() == HttpRequestMethod.DELETE) {
        // Future<Response<T>>
        response = await Dio().delete(request.url(),
            data: request.params, options: options);
      }
      // Dio 封装异常处理类
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      throw HiNetException(response?.statusCode ?? -1, error.toString(),
          data: buildHiNetResponse(response, request));
    }
    return buildHiNetResponse(response,request);
  }

  // 通过 DIO 构建 HiNet 返回值对象
  // Dio 返回为 Response
  buildHiNetResponse(Response response, BaseRequest request) {
    return HiNetResponse(
        data: response?.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response?.statusMessage,
        extra: response);
  }
}
