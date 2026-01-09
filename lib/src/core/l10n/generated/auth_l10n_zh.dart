// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AuthL10nZh extends AuthL10n {
  AuthL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get signInTitle => '欢迎回来';

  @override
  String get signInSubtitle => '登录以继续';

  @override
  String get emailLabel => '邮箱';

  @override
  String get emailHint => '请输入邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get passwordHint => '请输入密码';

  @override
  String get rememberMe => '记住我';

  @override
  String get signInButton => '登录';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get emailInvalid => '请输入有效的邮箱地址';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get passwordTooShort => '密码至少需要6个字符';

  @override
  String get fillAllFields => '请正确填写所有字段';

  @override
  String get invalidCredentials => '邮箱或密码错误';

  @override
  String get networkError => '网络错误，请检查您的连接';

  @override
  String get serverError => '服务器错误，请稍后重试';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get connectionTimeout => '连接超时，请重试';
}
