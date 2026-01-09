// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AuthL10nTh extends AuthL10n {
  AuthL10nTh([String locale = 'th']) : super(locale);

  @override
  String get signInTitle => 'ยินดีต้อนรับ';

  @override
  String get signInSubtitle => 'เข้าสู่ระบบเพื่อดำเนินการต่อ';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get emailHint => 'กรอกอีเมลของคุณ';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get passwordHint => 'กรอกรหัสผ่านของคุณ';

  @override
  String get rememberMe => 'จดจำฉัน';

  @override
  String get signInButton => 'เข้าสู่ระบบ';

  @override
  String get emailRequired => 'กรุณากรอกอีเมล';

  @override
  String get emailInvalid => 'กรุณากรอกอีเมลที่ถูกต้อง';

  @override
  String get passwordRequired => 'กรุณากรอกรหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get fillAllFields => 'กรุณากรอกข้อมูลให้ครบถ้วน';

  @override
  String get invalidCredentials => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get networkError => 'เกิดข้อผิดพลาดเครือข่าย กรุณาตรวจสอบการเชื่อมต่อ';

  @override
  String get serverError => 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์ กรุณาลองใหม่อีกครั้ง';

  @override
  String get unknownError => 'เกิดข้อผิดพลาดที่ไม่คาดคิด';

  @override
  String get connectionTimeout => 'หมดเวลาการเชื่อมต่อ กรุณาลองใหม่อีกครั้ง';
}
