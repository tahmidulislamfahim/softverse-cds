import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../models/cds_order_model.dart';

class CdsBillAmountsCard extends StatelessWidget {
  final CdsOrderModel? order;

  const CdsBillAmountsCard({super.key, this.order});

  static final _amount = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    final subtotal = order?.subtotal ?? 0;
    final tax = order?.tax ?? 0;
    final taxRatePercent = order?.taxRatePercent ?? 0;
    final total = order?.totalAmount ?? 0;
    final received = order?.amountReceived ?? 0;
    final change = order?.changeToReturn ?? 0;
    final isPaid = order?.isPaid ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bill Amounts',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.dashboardTextDark,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.cdsCardStroke),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.cdsBillGradientStart,
                AppColors.cdsBillGradientMid1,
                AppColors.cdsBillGradientMid2,
                AppColors.cdsBillGradientEnd,
              ],
            ),
          ),
          child: Column(
            children: [
              _Row(label: 'Subtotal', value: '\$${_amount.format(subtotal)}'),
              SizedBox(height: 4.h),
              _Row(
                label: 'TAX (${taxRatePercent.toStringAsFixed(1)}%)',
                value: '\$${_amount.format(tax)}',
              ),
              SizedBox(height: 11.h),
              const _DashedDivider(),
              SizedBox(height: 11.h),
              _Row(
                label: 'Total Amount',
                value: '\$${_amount.format(total)}',
                boldValue: true,
              ),
              // Amount received/change only exist once payment is actually
              // taken — showing them earlier would claim money changed
              // hands before it did.
              if (isPaid) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Amount Received',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '\$${_amount.format(received)}',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.dashboardTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                const _DashedDivider(),
                SizedBox(height: 11.h),
                _Row(
                  label: 'Change to Return',
                  value: '\$${_amount.format(change)}',
                  boldValue: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool boldValue;

  const _Row({required this.label, required this.value, this.boldValue = false});

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
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: getTextStyle(
            fontSize: boldValue ? 18 : 16,
            fontWeight: boldValue ? FontWeight.w500 : FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashGap = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashGap)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(right: dashGap),
              child: Container(
                width: dashWidth,
                height: 1,
                color: AppColors.cdsBillSectionDivider,
              ),
            ),
          ),
        );
      },
    );
  }
}
