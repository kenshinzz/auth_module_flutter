// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AuthL10nJa extends AuthL10n {
  AuthL10nJa([String locale = 'ja']) : super(locale);

  @override
  String get signInTitle => 'おかえりなさい';

  @override
  String get signInSubtitle => 'サインインして続行';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get emailHint => 'メールアドレスを入力';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get passwordHint => 'パスワードを入力';

  @override
  String get rememberMe => 'ログイン状態を保持';

  @override
  String get signInButton => 'サインイン';

  @override
  String get emailRequired => 'メールアドレスを入力してください';

  @override
  String get emailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get passwordRequired => 'パスワードを入力してください';

  @override
  String get passwordTooShort => 'パスワードは6文字以上必要です';

  @override
  String get fillAllFields => 'すべての項目を正しく入力してください';

  @override
  String get invalidCredentials => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get networkError => 'ネットワークエラー。接続を確認してください。';

  @override
  String get serverError => 'サーバーエラー。後でもう一度お試しください。';

  @override
  String get unknownError => '予期しないエラーが発生しました';

  @override
  String get connectionTimeout => '接続がタイムアウトしました。もう一度お試しください。';
}
