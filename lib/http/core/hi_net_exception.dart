

class HiNetException implements Exception{

  int code;
  String message;
  dynamic data;

  HiNetException(this.code,this.message,{this.data});

}

class NeedLogin extends HiNetException{
  NeedLogin({int code:401, String message:'请先登录'}) : super(code, message);

}

class NeedAuth extends HiNetException{
  NeedAuth(String message, {int code: 403, dynamic data}) : super(code, message,data: data);
}