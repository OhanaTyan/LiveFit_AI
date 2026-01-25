import 'dart:math';

/// 字符串工具类，提供各种字符串处理功能
class StringUtils {
  /// 判断字符串是否为空或仅包含空白字符
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// 判断字符串是否非空且包含实际字符
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  /// 截断字符串，超过指定长度时添加省略号
  static String truncate(String str, int maxLength, {String suffix = '...'}) {
    if (str.length <= maxLength) {
      return str;
    }
    return str.substring(0, maxLength - suffix.length) + suffix;
  }

  /// 首字母大写
  static String capitalize(String str) {
    if (isEmpty(str)) {
      return str;
    }
    return str[0].toUpperCase() + str.substring(1);
  }

  /// 全部单词首字母大写
  static String capitalizeAllWords(String str) {
    if (isEmpty(str)) {
      return str;
    }
    return str.split(' ').map(capitalize).join(' ');
  }

  /// 移除字符串两端的空白字符
  static String trim(String str) {
    return str.trim();
  }

  /// 移除字符串左侧的空白字符
  static String trimLeft(String str) {
    return str.trimLeft();
  }

  /// 移除字符串右侧的空白字符
  static String trimRight(String str) {
    return str.trimRight();
  }

  /// 替换字符串中的所有匹配项
  static String replaceAll(String str, String from, String to) {
    return str.replaceAll(from, to);
  }

  /// 替换字符串中的第一个匹配项
  static String replaceFirst(String str, String from, String to) {
    return str.replaceFirst(from, to);
  }

  /// 分割字符串
  static List<String> split(String str, String delimiter) {
    return str.split(delimiter);
  }

  /// 将列表连接成字符串
  static String join(List<String> list, String delimiter) {
    return list.join(delimiter);
  }

  /// 检查字符串是否包含指定的子字符串
  static bool contains(String str, String substring, {bool caseSensitive = true}) {
    if (caseSensitive) {
      return str.contains(substring);
    }
    return str.toLowerCase().contains(substring.toLowerCase());
  }

  /// 检查字符串是否以指定的前缀开头
  static bool startsWith(String str, String prefix) {
    return str.startsWith(prefix);
  }

  /// 检查字符串是否以指定的后缀结尾
  static bool endsWith(String str, String suffix) {
    return str.endsWith(suffix);
  }

  /// 转换为小写
  static String toLowerCase(String str) {
    return str.toLowerCase();
  }

  /// 转换为大写
  static String toUpperCase(String str) {
    return str.toUpperCase();
  }

  /// 移除字符串中的所有空白字符
  static String removeWhitespace(String str) {
    return str.replaceAll(RegExp(r'\s+'), '');
  }

  /// 检查字符串是否是有效的电子邮件地址
  static bool isValidEmail(String str) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(str);
  }

  /// 检查字符串是否是有效的电话号码（简单验证）
  static bool isValidPhone(String str) {
    final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
    return phoneRegex.hasMatch(str);
  }

  /// 格式化电话号码（添加分隔符）
  static String formatPhone(String str) {
    // 简单的电话号码格式化，可根据需要扩展
    if (str.length == 11) {
      return '${str.substring(0, 3)}-${str.substring(3, 7)}-${str.substring(7)}';
    }
    return str;
  }

  /// 隐藏部分字符串（用于敏感信息）
  static String maskString(String str, {int visibleChars = 4, String maskChar = '*'}) {
    if (str.length <= visibleChars) {
      return str;
    }
    final maskLength = str.length - visibleChars;
    return maskChar * maskLength + str.substring(maskLength);
  }

  /// 生成随机字符串
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
}
