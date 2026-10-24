import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/common/widgets/app_network_image.dart';
import '../../../core/utils/constants/colors.dart';
import '../models/cds_purchase_item_model.dart';

/// The one purchase-item card that also breaks down a bundle discount
/// (item row + bundle name + discount + subtotal), matching the "CDS Home"
/// Figma frame's keyboard entry.
class CdsBundleItemCard extends StatelessWidget {
  final CdsPurchaseItemModel item;

  const CdsBundleItemCard({super.key, required this.item});

  static final _amount = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final bundle = item.bundle!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cdsCardStroke),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardCardGradientStart,
            AppColors.dashboardCardGradientEnd,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: AppNetworkImage(
                  url: item.imageUrl,
                  width: 55.w,
                  height: 55.w,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dashboardTextDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'x ${item.quantity}',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.dashboardAccentBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${_amount.format(item.price)}',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.dashboardAccentBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _BreakdownRow(
            label: bundle.bundleName,
            value: '\$${_amount.format(bundle.bundlePrice)}',
          ),
          SizedBox(height: 8.h),
          _BreakdownRow(
            label: bundle.discountLabel,
            value: '\$${_amount.format(bundle.discountAmount)}',
          ),
          SizedBox(height: 8.h),
          _BreakdownRow(
            label: 'Sub Total',
            value: '\$${_amount.format(bundle.subtotal)}',
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _BreakdownRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.dashboardTextDark,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: getTextStyle(
            fontSize: emphasize ? 18 : 16,
            fontWeight: emphasize ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.dashboardAccentBlue,
          ),
        ),
      ],
    );
  }
}
