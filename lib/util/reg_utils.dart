
/// 正则表达校验
class RegCheckUtils {
  static bool isLocalImagePath(String path) {
    return RegExp(r'^/.+').hasMatch(path); // 匹配以 / 开头的本地路径
  }

  static bool isNetworkImagePath(String path) {
    return RegExp(r'^(http|https)://.+').hasMatch(path); // 匹配以 http 或 https 开头的网络路径
  }

  static bool isAssetPath(String path) {
    return RegExp(r'^[a-zA-Z0-9]+://').hasMatch(path); // 匹配以字母数字开头的资源路径
  }
}
