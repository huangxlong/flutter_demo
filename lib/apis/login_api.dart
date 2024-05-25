import 'package:flutter_demo/data/user.dart';
import 'package:flutter_demo/http/http_provider.dart';
import 'package:flutter_demo/http/http_result.dart';
import 'package:get/get.dart';

class LoginApi extends GetxService {
  HttpProvider httpProvider;

  LoginApi(this.httpProvider);

  Future<HttpResult<User>> login(String phone, String code) async {
    final map = <String, dynamic>{};
    map["phone"] = phone;
    map["smsCode"] = code;
    var result = await httpProvider.requestNetResult(
        "user-v2/mall/auth/loginPhone",
        params: map,
        method: HttpMethod.POST,
        isShowLoadingDialog: true);
    if (result.isSuccess) {
      var user = User.fromJson(result.getDataJson());
      return result.convert<User>(data: user);
    }
    return result.convert<User>();
  }
}
