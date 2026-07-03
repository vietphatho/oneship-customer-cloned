import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';

class OrderOptionSelectionContent extends StatelessWidget {
  const OrderOptionSelectionContent({
    super.key,
    required this.title,
    required this.resource,
    required this.selectedCodes,
    required this.onToggle,
  });

  final String title;
  final Resource<List<OrderOptionEntity>> resource;
  final List<String> selectedCodes;
  final void Function(String code, bool isSelected) onToggle;

  @override
  Widget build(BuildContext context) {
    final options = resource.data ?? const <OrderOptionEntity>[];

    return Scaffold(
      appBar: PrimaryAppBar(title: title),
      body: switch (resource.state) {
        Result.loading =>
          options.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _OptionsGrid(
                  options: options,
                  selectedCodes: selectedCodes,
                  onToggle: onToggle,
                ),
        Result.error => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
            child: PrimaryText(
              resource.message,
              style: AppTextStyles.bodySmall,
              color: AppColors.primary,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Result.success =>
          options.isEmpty
              ? const PrimaryEmptyData()
              : _OptionsGrid(
                  options: options,
                  selectedCodes: selectedCodes,
                  onToggle: onToggle,
                ),
      },
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
      //     child: SecondaryButton.filled(
      //       label: "done".tr(),
      //       onPressed: () => Navigator.of(context).pop(),
      //     ),
      //   ),
      // ),
    );
  }
}

class _OptionsGrid extends StatelessWidget {
  const _OptionsGrid({
    required this.options,
    required this.selectedCodes,
    required this.onToggle,
  });

  final List<OrderOptionEntity> options;
  final List<String> selectedCodes;
  final void Function(String code, bool isSelected) onToggle;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.mediumSpacing),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.smallSpacing,
        mainAxisSpacing: AppDimensions.smallSpacing,
        mainAxisExtent: 72,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        final selected = selectedCodes.contains(option.code);

        return _OrderOptionGridItem(
          option: option,
          selected: selected,
          onTap: () => onToggle(option.code, !selected),
        );
      },
    );
  }
}

class _OrderOptionGridItem extends StatelessWidget {
  const _OrderOptionGridItem({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final OrderOptionEntity option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral7,
            width: AppDimensions.mediumBorderStroke,
          ),
          borderRadius: AppDimensions.largeBorderRadius,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? CupertinoIcons.checkmark_square_fill
                  : CupertinoIcons.square,
              size: AppDimensions.smallIconSize,
              color: selected ? AppColors.primary : AppColors.neutral6,
            ),
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            Expanded(
              child: PrimaryText(
                option.name.isNotEmpty ? option.name : option.code,
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral2,
                bold: selected,
                maxLine: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
