/*
 * 网络请求引擎
 */
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../base/constant.dart';
import '../util/reg_utils.dart';
import 'interceptor/interceptor_auth_dio.dart';
import 'interceptor/interceptor_network_debounce.dart';

/*
 * 网络请求引擎封装，目前使用的是 Dio 框架
 */
class NetworkEngine {
  late Dio dio;

  NetworkEngine() {
    /// 网络配置
    final options = BaseOptions(
        baseUrl:  kReleaseMode ? Constant.BASE_RELASE_URL : Constant.BASE_DEBUG_URL,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (code) {
          //指定这些HttpCode都算成功
          if (code == 200 || code == 401 || code == 422 || code == 429) {
            return true;
          } else {
            return false;
          }
        });

    dio = Dio(options);

    // 设置Dio的转换器
    dio.transformer = BackgroundTransformer(); //Json后台线程处理优化（可选）

    // 设置Dio的拦截器
    dio.interceptors.add(NetworkDebounceInterceptor()); //处理网络请求去重逻辑
    dio.interceptors.add(AuthDioInterceptors()); //处理请求之前的请求头（项目业务逻辑）
    // dio.interceptors.add(StatusCodeDioInterceptors()); //处理响应之后的状态码（项目业务逻辑）
    // dio.interceptors.add(CacheControlnterceptor()); //处理 Http Get 请求缓存策略
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(responseBody: false)); //默认的 Dio 的 Log 打印
    }
  }

  /// 网络请求 Post 请求
  Future<Response> executePost({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? paths, //文件
    Map<String, Uint8List>? pathStreams, //文件流
    Map<String, String>? headers,
    ProgressCallback? send, // 上传进度监听
    ProgressCallback? receive, // 下载监听
    CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
  }) async {
    var map = <String, dynamic>{};

    if (params != null || paths != null || pathStreams != null) {
      //只要有一个不为空，就可以封装参数

      //默认的参数
      if (params != null) {
        map.addAll(params);
      }

      //Flie文件
      if (paths != null && paths.isNotEmpty) {
        for (final entry in paths.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value.isNotEmpty && RegCheckUtils.isLocalImagePath(value)) {
            // 以文件的方式压缩，获取到流对象
            Uint8List? stream = await FlutterImageCompress.compressWithFile(
              value,
              minWidth: 1000,
              minHeight: 1000,
              quality: 80,
            );

            //传入压缩之后的流对象
            if (stream != null) {
              map[key] = MultipartFile.fromBytes(stream, filename: "file");
            }
          }
        }
      }

      //File文件流
      if (pathStreams != null && pathStreams.isNotEmpty) {
        for (final entry in pathStreams.entries) {
          final key = entry.key;
          final value = entry.value;

          if (value.isNotEmpty) {
            // 以流方式压缩，获取到流对象
            Uint8List stream = await FlutterImageCompress.compressWithList(
              value,
              minWidth: 1000,
              minHeight: 1000,
              quality: 80,
            );

            //传入压缩之后的流对象
            map[key] = MultipartFile.fromBytes(stream, filename: "file_stream");
          }
        }
      }
    }

    final formData = FormData.fromMap(map);

    if (kDebugMode) {
      print('单独打印 Post 请求 FromData 参数为：fields:${formData.fields.toString()} files:${formData.files.toString()}');
    }

    return dio.post(
      url,
      data: map,
      options: Options(headers: headers),
      onSendProgress: send,
      onReceiveProgress: receive,
      cancelToken: cancelToken,
    );
  }

  /// 网络请求 Get 请求
  Future<Response> executeGet({
    required String url,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Duration? cacheExpiration,
    ProgressCallback? receive, // 请求进度监听
    CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
  }) {
    return dio.get(
      url,
      queryParameters: params,
      options: Options(headers: headers),
      onReceiveProgress: receive,
      cancelToken: cancelToken,
    );
  }

  /// Dio 网络下载
  Future<void> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? receive, // 下载进度监听
    CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
    void Function(bool success, String path)? callback, // 下载完成回调函数
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: receive,
        cancelToken: cancelToken,
      );
      // 下载成功
      callback?.call(true, savePath);
    } on DioException {
      // Log.e("DioException：$e");
      // 下载失败
      callback?.call(false, savePath);
    }
  }
}
