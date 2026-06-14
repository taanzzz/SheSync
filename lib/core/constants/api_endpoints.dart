import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:5000/api/v1';
    }
    return Platform.isAndroid
        ? 'http://192.168.0.182:5000/api/v1'
        : 'http://127.0.0.1:5000/api/v1';
  }

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/password/forgot-password';
  static const String verifyOtp = '/auth/password/verify-otp';
  static const String resetPassword = '/auth/password/reset-password';
  static const String changePassword = '/auth/password/change-password';
  static const String userProfile = '/users/me';
  static const String userSettings = '/users/me/settings';
  static const String userNotificationPrefs =
      '/users/me/notification-preferences';
  static const String fcmToken = '/users/me/fcm-token';
  static const String cycles = '/cycles';
  static const String cyclePrediction = '/cycles/prediction';
  static const String cycleCalendar = '/cycles/calendar';
  static const String cycleStatistics = '/cycles/statistics';
  static const String symptoms = '/symptoms';
  static const String symptomCategories = '/symptoms/categories';
  static const String symptomFrequency = '/symptoms/frequency';
  static const String fertilityWindow = '/fertility/window';
  static const String fertilityOvulation = '/fertility/ovulation';
  static const String bbt = '/fertility/bbt';
  static const String mucus = '/fertility/mucus';
  static const String fertilityChart = '/fertility/chart';
  static const String medicines = '/medicines';
  static const String medicinesToday = '/medicines/today';
  static const String medicinesAdherence = '/medicines/adherence';
  static const String appointments = '/appointments';
  static const String appointmentsUpcoming = '/appointments/upcoming';
  static const String doctors = '/appointments/doctors';
  static const String journals = '/journals';
  static const String moodTrends = '/journals/mood-trends';
  static const String vitals = '/vitals';
  static const String vitalsCharts = '/vitals/charts';
  static const String familyProfiles = '/family-profiles';
  static const String notificationsList = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
  static const String notificationsClearAll = '/notifications/clear-all';
  // ── Dynamic Cycle ──
  static const String cycleDashboard = '/cycles/dynamic/dashboard';
  static const String cycleAlerts = '/cycles/dynamic/alerts';
  static const String cycleFertility = '/cycles/dynamic/fertility';
  static const String cyclePremiumCalendar = '/cycles/dynamic/calendar/premium';
  static const String cycleConfig = '/cycles/dynamic/config';

  static const String reportsOverview = '/reports/overview';
  static const String reportsCycleAnalysis = '/reports/cycle-analysis';
  static const String reportsSymptomAnalysis = '/reports/symptom-analysis';
  static const String reportsExport = '/reports/export';
  static const String reportsMonthlySummary = '/reports/monthly-summary';

  // ── Water Tracking ──
  static const String waterConfig = '/water/config';
  static const String waterLog = '/water/log';
  static const String waterLogLast = '/water/log/last';
  static const String waterToday = '/water/today';
  static const String waterWeekly = '/water/weekly';
  static const String waterMonthly = '/water/monthly';
  static const String waterStreak = '/water/streak';

  // ── Mood Tracking ──
  static const String moods = '/moods';
  static const String moodToday = '/moods/today';
  static const String moodWeekly = '/moods/weekly';
  static const String moodMonthly = '/moods/monthly';
  static const String moodCycleCorrelation = '/moods/cycle-correlation';

  // ── Weight & BMI ──
  static const String weight = '/weight';
  static const String weightHistory = '/weight/history';
  static const String weightTrend = '/weight/trend';
  static const String weightBmi = '/weight/bmi';

  // ── Analytics ──
  static const String analyticsHealthScore = '/analytics/health-score';
  static const String analyticsDashboard = '/analytics/dashboard';

  // ── Smart Insights ──
  static const String insights = '/insights';
}
