import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/responsive.dart';
import '../../controller/cds_home_controller.dart';
import '../../widgets/cds_bill_amounts_card.dart';
import '../../widgets/cds_disconnected_view.dart';
import '../../widgets/cds_header.dart';
import '../../widgets/cds_order_banner.dart';
import '../../widgets/cds_purchase_items_section.dart';

class CdsHomeScreen extends GetView<CdsHomeController> {
  const CdsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CdsHeader(controller: controller),
        body: Obx(() {
          if (controller.connectionState.value ==
              CdsConnectionState.disconnected) {
            return Center(
              child: SingleChildScrollView(
                child: ResponsiveCenter(
                  maxWidth: 480,
                  alignment: Alignment.center,
                  child: CdsDisconnectedView(onReconnect: controller.reconnect),
                ),
              ),
            );
          }

          final order = controller.order.value;
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;

              if (isWide) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: ResponsiveCenter(
                    maxWidth: AppResponsive.maxContentWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side: Items list
                        Expanded(
                          flex: 6,
                          child: CdsPurchaseItemsSection(order: order),
                        ),
                        SizedBox(width: 24.w),
                        // Right side: Order Banner & Bill Totals
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CdsOrderBanner(
                                posLabel: controller.posLabel,
                                order: order,
                              ),
                              SizedBox(height: 12.h),
                              CdsBillAmountsCard(order: order),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Narrow / portrait phone
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: ResponsiveCenter(
                  maxWidth: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CdsOrderBanner(
                        posLabel: controller.posLabel,
                        order: order,
                      ),
                      SizedBox(height: 12.h),
                      CdsBillAmountsCard(order: order),
                      SizedBox(height: 22.h),
                      CdsPurchaseItemsSection(order: order),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
