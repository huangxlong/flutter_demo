class HttpResult<T> {
  HttpResult(
      {required this.isSuccess,
        dynamic dataJson,
        List<dynamic>? listJson,
        this.errorObj,
        this.code = -1,
        this.msg,
        this.errorMsg}) {
    this._dataJson = dataJson;
    this._listJson = listJson;
  }

  //是否成功
  bool isSuccess = false;

  //成功的数据（Json数据）
  dynamic _dataJson;
  List<dynamic>? _listJson;

  //成功的数据（真正的数据）
  T? data;
  List<T>? list;

  //当前返回对象的code，目前定义的是 code = 0 是成功
  int code = -1;
  //成功之后的消息
  String? msg;

  //失败的数据,失败对象
  dynamic errorObj;
  //失败的数据,失败字符串
  String? errorMsg;

  /// 以Json对象的方式获取data对象
  Map<String, dynamic> getDataJson() {
    if (_dataJson is Map<String, dynamic>) {
      return _dataJson as Map<String, dynamic>;
    }
    return {};
  }

  /// 以Json对象的方式获取Error对象
  Map<String, dynamic>? getErrorJson() {
    if (errorObj is Map<String, dynamic>) {
      return errorObj as Map<String, dynamic>;
    }
    return null;
  }

  /// 以原始对象的方式获取，可以获取到String,Int,bool等基本类型
  dynamic getDataDynamic() {
    return _dataJson;
  }

  /// 以数组的方式获取
  List<dynamic>? getListJson() {
    return _listJson;
  }

  /// 设置真正的数据对象
  void setData(T data) {
    this.data = data;
  }

  void setList(List<T> list) {
    this.list = list;
  }

  /// 基本类型转换为指定的泛型类型
  // ignore: avoid_shadowing_type_parameters
  HttpResult<T> convert<T>({T? data, List<T>? list}) {
    var result = HttpResult<T>(
        isSuccess: this.isSuccess,
        dataJson: this._dataJson,
        listJson: this._listJson,
        code: this.code,
        msg: this.msg,
        errorObj: this.errorObj,
        errorMsg: this.errorMsg);

    result.data = data;
    result.list = list;

    return result;
  }
}
