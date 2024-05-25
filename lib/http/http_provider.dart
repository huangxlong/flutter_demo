import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/base/constant.dart';

import 'http_result.dart';
import 'network_engine.dart';

enum CacheControl {
  noCache, //不使用缓存
  onlyCache, //只用缓存
  cacheFirstOrNetworkPut, //有缓存先用缓存，没有缓存进行网络请求再存入缓存
  onlyNetworkPutCache, //只用网络请求，但是会存入缓存
}

// ignore: constant_identifier_names
enum HttpMethod { GET, POST }

///Dio封装管理,网络请求引擎类
class HttpProvider {
  //具体的执行网络请求逻辑在引擎类中
  final networkEngine = NetworkEngine();

  /// 封装网络请求入口
  Future<HttpResult> requestNetResult(
      String url, {
        HttpMethod method = HttpMethod.GET, //指明Get还是Post请求
        Map<String, String>? headers, //请求头
        Map<String, dynamic>? params, //请求参数，Get的Params,Post的Form
        Map<String, String>? paths, //文件Flie
        Map<String, Uint8List>? pathStreams, //文件流
        CacheControl? cacheControl, // Get请求是否需要缓存
        Duration? cacheExpiration, //缓存是否需要过期时间，过期时间为多长时间
        ProgressCallback? send, // 上传进度监听
        ProgressCallback? receive, // 下载监听
        CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
        bool networkDebounce = false, // 当前网络请求是否需要网络防抖去重
        bool isShowLoadingDialog = false, // 是否展示 Loading 弹框
      }) async {
    //尝试网络请求去重,内部逻辑判断发起真正的网络请求
    if (networkDebounce) {
      if (headers == null || headers.isEmpty) {
        headers = <String, String>{};
      }
      headers['network_debounce'] = "true";
    }

    if (isShowLoadingDialog) {
      if (headers == null || headers.isEmpty) {
        headers = <String, String>{};
      }
      headers['is_show_loading_dialog'] = "true";
    }

    return _executeRequests(
      url,
      method,
      headers,
      params,
      paths,
      pathStreams,
      cacheControl,
      cacheExpiration,
      send,
      receive,
      cancelToken,
      networkDebounce,
    );
  }

  /// 真正的执行请求，处理缓存与返回的结果
  Future<HttpResult> _executeRequests(
      String url, //请求地址
      HttpMethod method, //请求方式
      Map<String, String>? headers, //请求头
      Map<String, dynamic>? params, //请求参数
      Map<String, String>? paths, //文件
      Map<String, Uint8List>? pathStreams, //文件流
      CacheControl? cacheControl, //Get请求缓存控制
      Duration? cacheExpiration, //缓存文件有效时间
      ProgressCallback? send, // 上传进度监听
      ProgressCallback? receive, // 下载监听
      CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
      bool networkDebounce, // 当前网络请求是否需要网络防抖去重
      ) async {
    try {
      //根据参数封装请求并开始请求
      Response response;

      // 定义一个局部函数，封装重复的请求逻辑
      Future<Response> executeGenerateRequest() async {
        return _generateRequest(
          method,
          params,
          paths,
          pathStreams,
          url,
          headers,
          cacheControl,
          cacheExpiration,
          send,
          receive,
          cancelToken,
        );
      }

      if (kDebugMode) {
        final startTime = DateTime.now();
        response = await executeGenerateRequest();
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime).inMilliseconds;
        print('网络请求耗时 $duration 毫秒,HttpCode:${response.statusCode} HttpMessage:${response.statusMessage} 响应内容 ${response.data}}');
      } else {
        response = await executeGenerateRequest();
      }

      //判断成功与失败, 200 成功  401 授权过期， 422 请求参数错误，429 请求校验不通过
      if (response.statusCode == 200 || response.statusCode == 401 || response.statusCode == 422 || response.statusCode == 429) {
        //网络请求完成之后获取正常的Json-Map
        Map<String, dynamic> jsonMap = response.data;

        //Http处理完了，现在处理 API 的 Code
        if (jsonMap.containsKey('code')) {
          int code = jsonMap['code'];

          // 如果有 code，并且 code = 0 说明成功
          if (code == Constant.NET_SUCCESS_CODE) {
            if (jsonMap['data'] is List<dynamic>) {
              //成功->返回数组
              return HttpResult(
                isSuccess: true,
                code: code,
                msg: jsonMap['msg'],
                listJson: jsonMap['data'], //赋值给的 listJson 字段
              );
            } else {
              //成功->返回对象
              return HttpResult(
                isSuccess: true,
                code: code,
                msg: jsonMap['msg'],
                dataJson: jsonMap['data'], //赋值给的 dataJson 字段
              );
            }

            //如果code !=0 ,下面是错误的情况判断
          } else {
            if (jsonMap.containsKey('errors')) {
              //拿到错误信息对象
              return HttpResult(isSuccess: false, code: code, errorObj: jsonMap['errors'], errorMsg: jsonMap['message']);
            } else if (jsonMap.containsKey('msg')) {
              //如果有msg字符串优先返回msg字符串
              return HttpResult(isSuccess: false, code: code, errorMsg: jsonMap['msg']);
            } else {
              //什么都没有就返回Http的错误字符串
              return HttpResult(isSuccess: false, code: code, errorMsg: jsonMap['message']);
            }
          }
        } else {
          //没有code，说明有错误信息，判断错误信息
          if (jsonMap.containsKey('errors')) {
            //拿到错误信息对象
            return HttpResult(isSuccess: false, errorObj: jsonMap['errors'], errorMsg: jsonMap['message']);
          } else if (jsonMap.containsKey('msg')) {
            //如果有msg字符串优先返回msg字符串
            return HttpResult(isSuccess: false, errorMsg: jsonMap['msg']);
          } else {
            //什么都没有就返回Http的错误字符串
            return HttpResult(isSuccess: false, errorMsg: jsonMap['message']);
          }
        }
      } else {
        //返回Http的错误,给 Http Response 的 statusMessage 值
        return HttpResult(
          isSuccess: false,
          code: response.statusCode ?? 202,
          errorMsg: response.statusMessage,
        );
      }
    } on DioException catch (e) {
      // Log.e("HttpProvider - DioException：$e  其他错误Error:${e.error.toString()}");
      if (e.response != null) {
        // 如果其他的Http网络请求的Code的处理
        // Log.d("网络请求错误，data：${e.response?.data}");
        return HttpResult(isSuccess: false, errorMsg: "错误码：${e.response?.statusCode} 错误信息：${e.response?.statusMessage}");
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return HttpResult(isSuccess: false, errorMsg: "网络连接超时，请稍后再试");
      } else if (e.type == DioExceptionType.cancel) {
        return HttpResult(isSuccess: false, errorMsg: "网络请求已取消");
      } else if (e.type == DioExceptionType.badCertificate) {
        return HttpResult(isSuccess: false, errorMsg: "网络连接证书无效");
      } else if (e.type == DioExceptionType.badResponse) {
        return HttpResult(isSuccess: false, errorMsg: "网络响应错误，请稍后再试");
      } else if (e.type == DioExceptionType.connectionError) {
        return HttpResult(isSuccess: false, errorMsg: "网络连接错误，请检查网络连接");
      } else if (e.type == DioExceptionType.unknown) {
        //未知错误中尝试打印具体的错误信息
        if (e.error != null) {
          if (e.error.toString().contains("HandshakeException")) {
            return HttpResult(isSuccess: false, errorMsg: "网络连接错误，请检查网络连接");
          } else {
            return HttpResult(isSuccess: false, errorMsg: e.error.toString()); //这里打印的就是英文错误了，没有格式化
          }
        } else {
          return HttpResult(isSuccess: false, errorMsg: "网络请求出现未知错误");
        }
      } else {
        //如果有response走Api错误
        return HttpResult(isSuccess: false, errorMsg: e.message);
      }
    }
  }

  ///生成对应Get与Post的请求体，并封装对应的参数
  Future<Response> _generateRequest(
      HttpMethod? method,
      Map<String, dynamic>? params,
      Map<String, String>? paths, //文件
      Map<String, Uint8List>? pathStreams, //文件流
      String url,
      Map<String, String>? headers,
      CacheControl? cacheControl,
      Duration? cacheExpiration,
      ProgressCallback? send, // 上传进度监听
      ProgressCallback? receive, // 下载监听
      CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
      ) async {
    if (method != null && method == HttpMethod.POST) {
      //以 Post 请求 FromData 的方式上传
      return networkEngine.executePost(
        url: url,
        params: params,
        paths: paths,
        pathStreams: pathStreams,
        headers: headers,
        send: send,
        receive: receive,
        cancelToken: cancelToken,
      );
    } else {
      //默认 Get 请求，添加逻辑是否需要处理缓存策略，具体缓存逻辑见拦截器

      if (cacheControl != null) {
        if (headers == null || headers.isEmpty) {
          headers = <String, String>{};
        }
        headers['cache_control'] = cacheControl.name;

        if (cacheExpiration != null) {
          headers['cache_expiration'] = cacheExpiration.inMilliseconds.toString();
        }
      }

      return networkEngine.executeGet(
        url: url,
        params: params,
        headers: headers,
        cacheExpiration: cacheExpiration,
        receive: receive,
        cancelToken: cancelToken,
      );
    }
  }
}
