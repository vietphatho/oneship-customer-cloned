import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/utils/currency_text_input_formatter.dart';

Future<void> showCreateOrderCodBottomSheet(
  BuildContext context, {
  required TextEditingController controller,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.xLargeRadius),
      ),
    ),
    builder:
        (context) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.mediumSpacing,
            AppDimensions.mediumSpacing,
            AppDimensions.mediumSpacing,
            MediaQuery.viewInsetsOf(context).bottom +
                AppDimensions.mediumSpacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral7,
                    borderRadius: AppDimensions.smallBorderRadius,
                  ),
                ),
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryText("cod".tr(), bold: true),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyTextInputFormatter()],
                suffixText: Constants.currencyUnit,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryButton.filled(
                label: "done".tr(),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
  );
}
