import 'package:softverse_cds/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/services/storage_service.dart';
import 'core/utils/responsive.dart';
import 'core/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return OrientationBuilder(
      builder: (context, _) {
        final media = MediaQueryData.fromView(View.of(context));
        final designSize = AppResponsive.getDesignSize(media.size);

        return ScreenUtilInit(
          key: ValueKey('${designSize.width}_${designSize.height}'),
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoute.getSplashScreen(),
              getPages: AppRoute.routes,
              initialBinding: ControllerBinder(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _initialThemeMode(),
            );
          },
        );
      },
    );
  }

  ThemeMode _initialThemeMode() {
    final saved = StorageService.themeMode;
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
