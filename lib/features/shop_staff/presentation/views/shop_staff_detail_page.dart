import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_staff/domain/entities/shop_staff_entity.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_bloc.dart';
import 'package:oneship_customer/features/shop_staff/presentation/bloc/shop_staff_state.dart';
import 'package:oneship_customer/features/shop_staff/presentation/widgets/shop_staff_detail_content.dart';

class ShopStaffDetailPage extends StatefulWidget {
  const ShopStaffDetailPage({super.key, this.staff});

  final ShopStaffEntity? staff;

  @override
  State<ShopStaffDetailPage> createState() => _ShopStaffDetailPageState();
}

class _ShopStaffDetailPageState extends State<ShopStaffDetailPage> {
  final ShopStaffBloc _shopStaffBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    final staff = widget.staff;
    if (staff != null) {
      _shopStaffBloc.fetchDetail(
        shopId: staff.shopId,
        staffId: staff.staffId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "shop_management.staff_detail_title".tr()),
      body: SafeArea(
        child: BlocBuilder<ShopStaffBloc, ShopStaffState>(
          bloc: _shopStaffBloc,
          builder: (context, state) {
            if (widget.staff == null) {
              return Center(
                child: PrimaryText(
                  "shop_management.staff_detail_not_found".tr(),
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }

            switch (state.staffDetailResource.state) {
              case Result.loading:
                return const Center(child: CircularProgressIndicator());
              case Result.error:
                return Center(
                  child: Padding(
                    padding: AppDimensions.mediumPaddingHorizontal,
                    child: PrimaryText(
                      state.staffDetailResource.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                      color: AppColors.primary,
                    ),
                  ),
                );
              case Result.success:
                final staff = state.staffDetailResource.data;
                if (staff == null) {
                  return const SizedBox.shrink();
                }
                return ShopStaffDetailContent(staff: staff);
            }
          },
        ),
      ),
    );
  }
}
