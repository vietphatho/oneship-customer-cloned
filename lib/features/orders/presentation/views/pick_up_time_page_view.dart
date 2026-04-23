import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_date_time_picker.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class PickUpTimePageView extends StatefulWidget {
  const PickUpTimePageView({super.key});

  @override
  State<PickUpTimePageView> createState() => _PickUpTimePageViewState();
}

class _PickUpTimePageViewState extends State<PickUpTimePageView> {
  final CreateOrderBloc _createOrderBloc = getIt.get();
  final TextEditingController _shopNameController = TextEditingController();

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      // buildWhen:
      //     (pre, cur) =>
      //         pre.request.detail?.pickupDate != cur.request.detail?.pickupDate,
      listener: _handleListener,
      builder: (context, state) {
        final CreateOrderRequestEntity request = state.draftRequest;
        final isStepValid =
            request.detail?.pickupDate != null &&
            request.detail?.pickupSession != null;
        _shopNameController.text = state.shopInfo.shopName;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                "Thông tin người gửi",
                style: AppTextStyles.headlineSmall,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryText("Tên cửa hàng", style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              PrimaryTextField(controller: _shopNameController, enabled: false),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryDateTimePicker(
                label: "pick_up_date".tr(),
                isRequired: true,
                initialDateTime: request.detail?.pickupDate,
                firstDate: DateTime.now(),
                onChanged:
                    (date) => _createOrderBloc.changePickUpDate(date: date),
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryDropdown(
                label: "pick_up_time".tr(),
                isRequired: true,
                initialValue: request.detail?.pickupSession,
                menu: OrderPickUpSession.values,
                hintText: "Chọn thời gian",
                toLabel: (item) => item.label,
                onSelected:
                    (value) =>
                        _createOrderBloc.changePickUpDate(session: value),
              ),
              const Spacer(),
              SafeArea(
                child: PrimaryButton.supportingPrimary(
                  label: "next".tr(),
                  onPressed:
                      isStepValid ? _createOrderBloc.completeDateStep : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleListener(BuildContext context, CreateOrderState state) {
    if (state is CreateOrderPickUpTimeChangedState) {}
  }
}
