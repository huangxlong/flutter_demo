import 'package:dio/dio.dart';

/*
 * 用户授权加密等相关处理的拦截器
 */
class AuthDioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    //拿到现有的Headers
    Map<String, dynamic> headers = options.headers;

    headers['accept'] = 'application/json';

    // 设置需要添加平台信息，App版本信息等

    // 每个接口添加自定义的设备UUID标识

    //如果有通行令牌，都带上通行令牌

    // 参数加密

    // 通讯加密


    //设置给Option对象
    options.headers = headers;

    super.onRequest(options, handler);
  }


}
