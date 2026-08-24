import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../models/cds_order_model.dart';

class CdsOrderBanner extends StatelessWidget {
  final String posLabel;
  final CdsOrderModel? order;

  const CdsOrderBanner({super.key, required this.posLabel, this.order});

  @override
  Widget build(BuildContext context) {
    final orderPart = order == null ? '- -' : order!.orderNumber.toString();
    final itemsPart = order == null ? '- -' : order!.totalItems.toString();
    final companyLine = order?.companyName ?? '--------------';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cdsOrderBannerStroke),
        gradient: const LinearGradient(
          colors: [AppColors.gaugeYellowStart, AppColors.gaugeYellowEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$posLabel Order-$orderPart',
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.dashboardTextDark,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Total Item- $itemsPart',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dashboardTextDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            companyLine,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.dashboardTextDark,
            ),
          ),
        ],
      ),
    );
  }
}
