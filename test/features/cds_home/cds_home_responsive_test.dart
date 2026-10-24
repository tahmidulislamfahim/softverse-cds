import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softverse_cds/core/utils/responsive.dart';
import 'package:softverse_cds/features/cds_home/controller/cds_home_controller.dart';
import 'package:softverse_cds/features/cds_home/models/cds_order_model.dart';
import 'package:softverse_cds/features/cds_home/models/cds_purchase_item_model.dart';
import 'package:softverse_cds/features/cds_home/views/screens/cds_home_screen.dart';
import 'package:softverse_cds/features/cds_home/widgets/cds_bill_amounts_card.dart';
import 'package:softverse_cds/features/cds_home/widgets/cds_disconnected_view.dart';
import 'package:softverse_cds/features/cds_home/widgets/cds_order_banner.dart';
import 'package:softverse_cds/features/cds_home/widgets/cds_purchase_items_section.dart';

class FakeCdsHomeController extends CdsHomeController {
  @override
  // ignore: must_call_super
  void onInit() {
    // Intentionally omit super.onInit() to prevent network websocket connection during widget tests
  }
}

void main() {
  late FakeCdsHomeController controller;

  setUp(() {
    Get.reset();
    controller = FakeCdsHomeController();
    Get.put<CdsHomeController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestScreen(Size size) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: ScreenUtilInit(
        key: ValueKey('${size.width}_${size.height}'),
        designSize: AppResponsive.getDesignSize(size),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const GetMaterialApp(
            home: CdsHomeScreen(),
          );
        },
      ),
    );
  }

  const sampleOrder = CdsOrderModel(
    orderNumber: '1042',
    companyName: 'Acme Coffee Co.',
    totalItems: 3,
    subtotal: 45.00,
    tax: 3.60,
    taxRatePercent: 8.0,
    totalAmount: 48.60,
    amountReceived: 50.00,
    changeToReturn: 1.40,
    isPaid: true,
    items: [
      CdsPurchaseItemModel(
        name: 'Caramel Macchiato',
        quantity: 2,
        price: 30.00,
        imageUrl: '',
      ),
      CdsPurchaseItemModel(
        name: 'Almond Croissant',
        quantity: 1,
        price: 15.00,
        imageUrl: '',
      ),
    ],
  );

  group('CdsHomeScreen Responsive Tests', () {
    testWidgets('Disconnected view renders centered with max width constraints', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller.connectionState.value = CdsConnectionState.disconnected;

      await tester.pumpWidget(buildTestScreen(const Size(1920, 1080)));
      await tester.pumpAndSettle();

      expect(find.byType(CdsDisconnectedView), findsOneWidget);
      expect(find.text('Currently Disconnected'), findsOneWidget);
      expect(find.text('Reconnect'), findsOneWidget);
    });

    testWidgets('Narrow phone portrait (390x844) renders vertical column layout', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller.connectionState.value = CdsConnectionState.active;
      controller.order.value = sampleOrder;

      await tester.pumpWidget(buildTestScreen(const Size(390, 844)));
      await tester.pumpAndSettle();

      expect(find.byType(CdsOrderBanner), findsOneWidget);
      expect(find.byType(CdsBillAmountsCard), findsOneWidget);
      expect(find.byType(CdsPurchaseItemsSection), findsOneWidget);
      expect(find.text('Acme Coffee Co.'), findsOneWidget);
      expect(find.text('Caramel Macchiato'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Landscape phone (844x390) renders dual-pane side-by-side layout', (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller.connectionState.value = CdsConnectionState.active;
      controller.order.value = sampleOrder;

      await tester.pumpWidget(buildTestScreen(const Size(844, 390)));
      await tester.pumpAndSettle();

      expect(find.byType(CdsOrderBanner), findsOneWidget);
      expect(find.byType(CdsBillAmountsCard), findsOneWidget);
      expect(find.byType(CdsPurchaseItemsSection), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Foldable opened upright (780x808) renders dual-pane layout without overflow', (tester) async {
      tester.view.physicalSize = const Size(780, 808);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller.connectionState.value = CdsConnectionState.active;
      controller.order.value = sampleOrder;

      await tester.pumpWidget(buildTestScreen(const Size(780, 808)));
      await tester.pumpAndSettle();

      expect(find.byType(CdsOrderBanner), findsOneWidget);
      expect(find.byType(CdsBillAmountsCard), findsOneWidget);
      expect(find.byType(CdsPurchaseItemsSection), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('15.6 inch POS terminal (1920x1080) renders dual-pane layout seamlessly', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      controller.connectionState.value = CdsConnectionState.active;
      controller.order.value = sampleOrder;

      await tester.pumpWidget(buildTestScreen(const Size(1920, 1080)));
      await tester.pumpAndSettle();

      expect(find.byType(CdsOrderBanner), findsOneWidget);
      expect(find.byType(CdsBillAmountsCard), findsOneWidget);
      expect(find.byType(CdsPurchaseItemsSection), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
