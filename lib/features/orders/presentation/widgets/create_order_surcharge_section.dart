import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/currency_text_input_formatter.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class CreateOrderSurchargeSection extends StatelessWidget {
  const CreateOrderSurchargeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.surchargeGroupsResource != current.surchargeGroupsResource,
      builder: (context, state) {
        if (state.surchargeGroupsResource.state == Result.loading &&
            state.surchargeGroups.isEmpty) {
          return PrimaryText(
            "loading".tr(),
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral5,
          );
        }

        if (state.surchargeGroupsResource.state == Result.error) {
          return PrimaryText(
            state.surchargeGroupsResource.message,
            style: AppTextStyles.bodySmall,
            color: AppColors.primary,
          );
        }

        if (state.surchargeGroups.isEmpty) {
          return PrimaryText(
            "no_surcharge_services".tr(),
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral5,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              "surcharge".tr(),
              style: AppTextStyles.bodySmall,
              bold: true,
            ),
            AppSpacing.vertical(AppDimensions.xSmallSpacing),
            ...List.generate(
              state.surchargeGroups.length,
              (index) => _SurchargeGroupView(groupIndex: index),
            ),
          ],
        );
      },
    );
  }
}

class _SurchargeGroupView extends StatelessWidget {
  const _SurchargeGroupView({required this.groupIndex});

  final int groupIndex;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.surchargeGroupsResource != current.surchargeGroupsResource,
      builder: (context, state) {
        if (groupIndex >= state.surchargeGroups.length) {
          return const SizedBox.shrink();
        }

        final group = state.surchargeGroups[groupIndex];
        final visibleSurcharges = group.surcharges
            .where(
              (surcharge) => surcharge.isEnabled && surcharge.isVisibleOnShop,
            )
            .toList();

        if (visibleSurcharges.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (group.groupName.isNotEmpty) ...[
                PrimaryText(
                  group.groupName,
                  style: AppTextStyles.bodySmall,
                  color: AppColors.neutral5,
                  fontWeight: FontWeight.w600,
                ),
                AppSpacing.vertical(AppDimensions.xxSmallSpacing),
              ],
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: visibleSurcharges.length,
                separatorBuilder: (context, index) =>
                    AppSpacing.vertical(AppDimensions.xSmallSpacing),
                itemBuilder: (context, index) {
                  return _SurchargeItem(
                    surchargeCode: visibleSurcharges[index].code,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SurchargeItem extends StatelessWidget {
  const _SurchargeItem({required this.surchargeCode});

  final String surchargeCode;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.selectedSurchargeCodes != current.selectedSurchargeCodes ||
          previous.surchargeInputValues != current.surchargeInputValues ||
          previous.surchargeValidationErrors !=
              current.surchargeValidationErrors ||
          previous.surchargeGroupsResource != current.surchargeGroupsResource,
      builder: (context, state) {
        final surcharge = state.findSurcharge(surchargeCode);
        if (surcharge == null) return const SizedBox.shrink();

        final isSelected = state.selectedSurchargeCodes.contains(surchargeCode);

        return PrimaryFrame(
          padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
          child: Column(
            children: [
              PrimaryAnimatedPressableWidget(
                onTap: () => bloc.toggleSurcharge(surchargeCode, !isSelected),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: AppDimensions.smallIconSize,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.neutral5,
                    ),
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    Expanded(
                      child: PrimaryText(
                        surcharge.label,
                        style: AppTextStyles.bodySmall,
                        color: AppColors.neutral2,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected && surcharge.requiresValue) ...[
                AppSpacing.vertical(AppDimensions.xSmallSpacing),
                _SurchargeValueField(surchargeCode: surchargeCode),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SurchargeValueField extends StatefulWidget {
  const _SurchargeValueField({required this.surchargeCode});

  final String surchargeCode;

  @override
  State<_SurchargeValueField> createState() => _SurchargeValueFieldState();
}

class _SurchargeValueFieldState extends State<_SurchargeValueField> {
  late final TextEditingController _controller;
  int? _syncedValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(int? value) {
    if (_syncedValue == value) return;

    _syncedValue = value;
    final formatted = Utils.formatCurrencyInput(value);
    if (_controller.text == formatted) return;

    _controller.text = formatted;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.surchargeInputValues[widget.surchargeCode] !=
              current.surchargeInputValues[widget.surchargeCode] ||
          previous.surchargeValidationErrors[widget.surchargeCode] !=
              current.surchargeValidationErrors[widget.surchargeCode] ||
          previous.surchargeGroupsResource != current.surchargeGroupsResource,
      builder: (context, state) {
        final surcharge = state.findSurcharge(widget.surchargeCode);
        final value = state.surchargeInputValues[widget.surchargeCode];
        final errorText = state.surchargeValidationErrors[widget.surchargeCode];

        _syncController(value);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextField(
              controller: _controller,
              hintText: surcharge?.customNote ?? "enter_surcharge_value".tr(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                CurrencyTextInputFormatter(),
              ],
              suffixText: Constants.currencyUnit,
              onChanged: (value) {
                final parsed = Utils.parseCurrencyInput(value);
                bloc.updateSurchargeValue(
                  widget.surchargeCode,
                  parsed > 0 ? parsed : null,
                );
              },
            ),
            if (errorText != null) ...[
              AppSpacing.vertical(AppDimensions.xxSmallSpacing),
              PrimaryText(
                errorText.tr(),
                style: AppTextStyles.bodySmall,
                color: AppColors.primary,
              ),
            ],
          ],
        );
      },
    );
  }
}
