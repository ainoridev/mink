// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordMinLength => 'Minimum 6 characters';

  @override
  String get signIn => 'Sign in';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get orSeparator => 'or';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get noAccount => 'I don\'t have an account';

  @override
  String get register => 'Register';

  @override
  String get acceptPolicy => 'I accept the privacy policy';

  @override
  String get emailAlreadyRegistered =>
      'This email is already registered. Please sign in.';

  @override
  String get operationFailed => 'Could not complete the operation.';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String get confirmationSent =>
      'We sent you a confirmation link. Activate it to sign in.';

  @override
  String get alreadyConfirmed => 'I already confirmed my email';

  @override
  String get forgotPasswordTitle => 'Forgot my password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email and we will send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get resetPasswordEmailSent =>
      'Check your email for a password reset link.';

  @override
  String get termsAcceptanceDescription =>
      'You must accept the privacy policy to continue using the app.';

  @override
  String get acceptAndContinue => 'Accept and continue';

  @override
  String get signOut => 'Sign out';

  @override
  String get back => 'Back';
}
