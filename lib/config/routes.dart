import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_welcome_screen.dart';
import '../screens/auth/onboarding_rewards_screen.dart';
import '../screens/auth/onboarding_impact_screen.dart';
import '../screens/home/landing_page.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/buyers_marketplace_screen.dart';
import '../screens/dashboard/collector_dashboard_screen.dart';
import '../screens/ewaste/ewaste_locator_screen.dart';
import '../screens/scan/qr_scanner_screen.dart';
import '../screens/pickup/schedule_pickup_screen.dart';
import '../screens/report/create_report_screen.dart';
import '../screens/report/map_view_screen.dart';
import '../screens/wallet/rewards_screen.dart';
import '../screens/settings/profile_settings_screen.dart';

class AppRoutes {
  // Auth Routes
  static const String landing = '/';
  static const String login = '/login';
  static const String onboardingWelcome = '/onboarding-welcome';
  static const String onboardingRewards = '/onboarding-rewards';
  static const String onboardingImpact = '/onboarding-impact';

  // Main App Routes
  static const String home = '/home';
  static const String buyersMarketplace = '/buyers-marketplace';
  static const String collectorDashboard = '/collector-dashboard';
  static const String scan = '/scan';
  static const String uploadProof = '/upload-proof';
  static const String schedulePickup = '/schedule-pickup';
  static const String createReport = '/create-report';
  static const String mapView = '/map-view';
  static const String wallet = '/wallet';
  static const String rewards = '/rewards';
  static const String profileSettings = '/profile-settings';
  static const String eWasteLocator = '/ewaste-locator';


  // Route Map
  static Map<String, WidgetBuilder> routes = {
    landing: (context) => const LandingPage(),
    login: (context) => const LoginScreen(),
    onboardingWelcome: (context) => const OnboardingWelcomeScreen(),
    onboardingRewards: (context) => const OnboardingRewardsScreen(),
    onboardingImpact: (context) => const OnboardingImpactScreen(),
    home: (context) => const CitizenDashboardScreen(),
    buyersMarketplace: (context) => const BuyersMarketplaceScreen(),
    collectorDashboard: (context) => const CollectorDashboardScreen(),
    scan: (context) => const QRScannerScreen(),
    schedulePickup: (context) => const SchedulePickupScreen(),
    createReport: (context) => const CreateReportScreen(),
    mapView: (context) => const MapViewScreen(),
    rewards: (context) => const RewardsStoreScreen(),
    profileSettings: (context) => const ProfileSettingsScreen(),
    eWasteLocator: (context) => const EWasteLocatorScreen(),
  };

  // Initial Route
  static const String initialRoute = landing;
}