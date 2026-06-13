import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/calendar/screens/calendar_screen.dart';
import '../features/period_log/screens/period_log_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/symptoms/screens/symptom_log_screen.dart';
import '../features/medicine/screens/medicine_screen.dart';
import '../features/journal/screens/journal_screen.dart';
import '../features/fertility/screens/fertility_screen.dart';
import '../features/reports/screens/reports_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String calendar = '/calendar';
  static const String periodLog = '/period-log';
  static const String symptomLog = '/symptom-log';
  static const String medicine = '/medicine';
  static const String journal = '/journal';
  static const String fertility = '/fertility';
  static const String reports = '/reports';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _pageRoute(const SplashScreen(), routeSettings);
      case onboarding:
        return _pageRoute(const OnboardingScreen(), routeSettings);
      case login:
        return _pageRoute(const LoginScreen(), routeSettings);
      case register:
        return _pageRoute(const RegisterScreen(), routeSettings);
      case forgotPassword:
        return _pageRoute(const ForgotPasswordScreen(), routeSettings);
      case home:
        return _pageRoute(const HomeScreen(), routeSettings);
      case settings:
        return _pageRoute(const SettingsScreen(), routeSettings);
      case calendar:
        return _pageRoute(const CalendarScreen(), routeSettings);
      case periodLog:
        return _pageRoute(const PeriodLogScreen(), routeSettings);
      case symptomLog:
        return _pageRoute(const SymptomLogScreen(), routeSettings);
      case medicine:
        return _pageRoute(const MedicineScreen(), routeSettings);
      case journal:
        return _pageRoute(const JournalScreen(), routeSettings);
      case fertility:
        return _pageRoute(const FertilityScreen(), routeSettings);
      case reports:
        return _pageRoute(const ReportsScreen(), routeSettings);
      default:
        return _pageRoute(const SplashScreen(), routeSettings);
    }
  }

  static PageRoute _pageRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
