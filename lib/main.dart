import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/config/app_config.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
 import 'package:shadcn_ui/shadcn_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51RBVto9PIZrH7FfFE4kvaqo1kIzXj4E7Uojt2EimpTFnFbJ3oDLzczbqNhz03fFes9Z5j56J7b9hsGiiVImzRLwr0048bb94VP';
  Stripe.merchantIdentifier = 'merchant.com.kanchanaburi.app';
  runApp(const KanchanaburiApp());
}

class KanchanaburiApp extends StatelessWidget {
  const KanchanaburiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadGreenColorScheme.light(),
      ),
      appBuilder: (context) {
        return GetMaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
