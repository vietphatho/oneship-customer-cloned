import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_date_time_picker.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

class PickUpTimePageView extends StatefulWidget {
  const PickUpTimePageView({super.key});

  @override
  State<PickUpTimePageView> createState() => _PickUpTimePageViewState();
}

class _PickUpTimePageViewState extends State<PickUpTimePageView> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  final TextEditingController _pickUpDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      // buildWhen:
      //     (pre, cur) =>
      //         pre.request.detail?.pickupDate != cur.request.detail?.pickupDate,
      listener: _handleListener,
      builder: (context, state) {
        CreateOrderEntity request = state.request;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumSpacing,
            vertical: AppDimensions.mediumSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText("pick_up_info".tr()),
              AppSpacing.vertical(AppDimensions.mediumSpacing),

              PrimaryDateTimePicker(
                label: "pick_up_date".tr(),
                initialDateTime: request.detail?.pickupDate,
                // textEditingController: _pickUpDateController,
                onChanged:
                    (date) => _createOrderBloc.changePickUpDate(date: date),
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryDropdown(
                label: "pick_up_time".tr(),
                initialValue: request.detail?.pickUpSession,
                menu: OrderPickUpSession.values,
                toLabel: (item) => item.name,
                onSelected:
                    (value) =>
                        _createOrderBloc.changePickUpDate(session: value),
              ),
              const Spacer(),
              SafeArea(
                child: PrimaryButton.primaryButton(
                  label: "next".tr(),
                  onPressed: _createOrderBloc.completeDateStep,
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
