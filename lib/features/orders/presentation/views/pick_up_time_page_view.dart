import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_date_time_picker.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
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
        final selectedDate = request.detail?.pickupDate;
        final selectedSession = request.detail?.pickupSession;
        final availableSessions =
            OrderPickUpSessionExt.availableSessionsForDate(selectedDate);
        final effectiveSession =
            (selectedSession != null &&
                    availableSessions.contains(selectedSession))
                ? selectedSession
                : null;
        final isStepValid =
            selectedDate != null &&
            effectiveSession != null &&
            availableSessions.isNotEmpty;
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
                "sender_info".tr(),
                style: AppTextStyles.headlineSmall,
              ),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryText("shop_name".tr(), style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              PrimaryTextField(controller: _shopNameController, enabled: false),
              AppSpacing.vertical(AppDimensions.mediumSpacing),
              PrimaryDateTimePicker(
                label: "pick_up_date".tr(),
                isRequired: true,
                initialDateTime: request.detail?.pickupDate,
                firstDate: DateTime.now(),
                onChanged: (date) {
                  // Kiểm tra nếu session hiện tại không còn hợp lệ sau khi đổi ngày
                  final currentSession = request.detail?.pickupSession;
                  final sessions =
                      OrderPickUpSessionExt.availableSessionsForDate(date);
                  final sessionStillValid =
                      currentSession != null &&
                      sessions.contains(currentSession);
                  _createOrderBloc.changePickUpDate(
                    date: date,
                    // Nếu session không còn hợp lệ, đặt về null để buộc user chọn lại
                    session: sessionStillValid ? currentSession : null,
                  );
                },
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryDropdown(
                label: "pick_up_time".tr(),
                isRequired: true,
                initialValue: effectiveSession,
                menu: availableSessions,
                hintText: "select_time".tr(),
                toLabel: (item) => item.label.tr(),
                onSelected:
                    (value) =>
                        _createOrderBloc.changePickUpDate(session: value),
              ),
              const Spacer(),
              SafeArea(
                child: SecondaryButton.filled(
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
