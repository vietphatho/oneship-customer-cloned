import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class MarketSenderInfoSection extends StatefulWidget {
  const MarketSenderInfoSection({super.key, this.enabled = true});

  final bool enabled;

  @override
  State<MarketSenderInfoSection> createState() =>
      _MarketSenderInfoSectionState();
}

class _MarketSenderInfoSectionState extends State<MarketSenderInfoSection> {
  final ShopBloc _shopBloc = getIt.get();
  final CreateOrderBloc _createOrderBloc = getIt.get();
  ShopVendorEntity? _selectedVendor;

  @override
  Widget build(BuildContext context) {
    return PrimaryFrame(
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            "Người gửi",
            style: AppTextStyles.labelLarge,
            color: AppColors.primary,
            bold: true,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          BlocBuilder<ShopBloc, ShopState>(
            bloc: _shopBloc,
            buildWhen: (previous, current) =>
                previous.shopVendorsResource != current.shopVendorsResource,
            builder: (context, state) {
              final vendors = state.shopVendors;
              final selectedVendor =
                  _selectedVendor ?? _initialSelectedVendor(vendors);
              return PrimaryDropdown<ShopVendorEntity>(
                label: "Tiểu thương",
                hintText: widget.enabled
                    ? "Chọn tiểu thương"
                    : "Chưa có thông tin tiểu thương",
                menu: vendors,
                enabled: widget.enabled && vendors.isNotEmpty,
                initialValue: selectedVendor,
                toLabel: (vendor) => vendor.vendorName,
                onSelected: (vendor) {
                  setState(() => _selectedVendor = vendor);
                  _createOrderBloc.changeMarketVendor(vendor);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  ShopVendorEntity? _initialSelectedVendor(List<ShopVendorEntity> vendors) {
    final externalId = _createOrderBloc.state.request.externalId;
    if (externalId?.isNotEmpty != true) return null;

    return vendors.firstWhereOrNull((vendor) => vendor.userId == externalId);
  }
}
