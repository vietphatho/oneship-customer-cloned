import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/core/utils/currency_text_input_formatter.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class CreateOrderSurchargeSection extends StatelessWidget {
  const CreateOrderSurchargeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen: (previous, current) =>
          previous.visibleSurchargeGroupsResource !=
          current.visibleSurchargeGroupsResource,
      builder: (context, shopState) {
        final resource = shopState.visibleSurchargeGroupsResource;
        final groups = shopState.visibleSurchargeGroups;

        // if (resource.state == Result.loading && groups.isEmpty) {
        //   return PrimaryText(
        //     "loading".tr(),
        //     style: AppTextStyles.bodySmall,
        //     color: AppColors.neutral5,
        //   );
        // }

        if (resource.state == Result.error) {
          return PrimaryText(
            resource.message,
            style: AppTextStyles.bodySmall,
            color: AppColors.primary,
          );
        }

        if (groups.isEmpty) {
          return PrimaryText(
            "no_surcharge_services".tr(),
            style: AppTextStyles.bodySmall,
            color: AppColors.neutral5,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PrimaryText(
            //   "surcharge".tr(),
            //   style: AppTextStyles.bodySmall,
            //   bold: true,
            // ),
            // AppSpacing.vertical(AppDimensions.xSmallSpacing),
            ...List.generate(
              groups.length,
              (index) => _SurchargeGroupView(group: groups[index]),
            ),
          ],
        );
      },
    );
  }
}

class _SurchargeGroupView extends StatelessWidget {
  const _SurchargeGroupView({required this.group});

  final SurchargeGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final visibleSurcharges = group.surcharges
        .where((surcharge) => surcharge.isEnabled && surcharge.isVisibleOnShop)
        .toList();

    if (visibleSurcharges.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.groupName.isNotEmpty) ...[
            PrimaryText(group.groupName, style: AppTextStyles.labelSmall),
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
              return _SurchargeItem(surcharge: visibleSurcharges[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _SurchargeItem extends StatelessWidget {
  const _SurchargeItem({required this.surcharge});

  final SurchargeEntity surcharge;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<CreateOrderBloc>();
    final surchargeCode = surcharge.code;

    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: bloc,
      buildWhen: (previous, current) =>
          previous.selectedSurchargeCodes != current.selectedSurchargeCodes ||
          previous.surchargeInputValues != current.surchargeInputValues ||
          previous.surchargeValidationErrors !=
              current.surchargeValidationErrors,
      builder: (context, state) {
        final isSelected = state.selectedSurchargeCodes.contains(surchargeCode);

        return PrimaryFrame(
          padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PrimaryAnimatedPressableWidget(
                      onTap: () =>
                          bloc.toggleSurcharge(surchargeCode, !isSelected),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppDimensions.xxSmallSpacing,
                            ),
                            child: Icon(
                              isSelected
                                  ? CupertinoIcons.checkmark_square_fill
                                  : CupertinoIcons.square,
                              size: AppDimensions.smallIconSize,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.neutral6,
                            ),
                          ),
                          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(
                                  surcharge.label,
                                  style: AppTextStyles.bodySmall,
                                  color: AppColors.neutral2,
                                ),
                                PrimaryText(
                                  surcharge.displayText,
                                  style: AppTextStyles.bodyXSmall,
                                  color: AppColors.neutral5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (surcharge.tiers.isNotEmpty) ...[
                    AppSpacing.horizontal(AppDimensions.xSmallSpacing),
                    InkWell(
                      borderRadius: AppDimensions.smallBorderRadius,
                      onTap: () => context.push(
                        RouteName.surchargeDetailPage,
                        extra: surcharge,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(AppDimensions.xxSmallSpacing),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: AppDimensions.xSmallIconSize,
                          color: AppColors.neutral6,
                        ),
                      ),
                    ),
                  ],
                ],
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
              current.surchargeValidationErrors[widget.surchargeCode],
      builder: (context, state) {
        final shopBloc = getIt.get<ShopBloc>();
        final surcharge = shopBloc.state.visibleSurcharges.firstWhereOrNull(
          (surcharge) => surcharge.code == widget.surchargeCode,
        );
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
