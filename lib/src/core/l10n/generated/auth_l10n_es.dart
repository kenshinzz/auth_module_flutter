// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'auth_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AuthL10nEs extends AuthL10n {
  AuthL10nEs([String locale = 'es']) : super(locale);

  @override
  String get signInTitle => 'Bienvenido';

  @override
  String get signInSubtitle => 'Inicia sesión para continuar';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingresa tu correo';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get rememberMe => 'Recuérdame';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get emailRequired => 'El correo es requerido';

  @override
  String get emailInvalid => 'Por favor ingresa un correo válido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get fillAllFields =>
      'Por favor completa todos los campos correctamente';

  @override
  String get invalidCredentials => 'Correo o contraseña inválidos';

  @override
  String get networkError => 'Error de red. Por favor verifica tu conexión.';

  @override
  String get serverError => 'Error del servidor. Por favor intenta más tarde.';

  @override
  String get unknownError => 'Ocurrió un error inesperado';

  @override
  String get connectionTimeout =>
      'Tiempo de conexión agotado. Por favor intenta de nuevo.';
}
