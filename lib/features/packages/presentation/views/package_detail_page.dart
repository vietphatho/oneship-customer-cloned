import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/packages/data/models/response/package_detail.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/packages/presentation/widgets/order_of_pkg_info_item.dart';

class PackageDetailPage extends StatefulWidget {
  const PackageDetailPage({super.key});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  final PackagesBloc _packagesBloc = getIt.get();

  late PackageDetail pkg;

  TextStyle _valueStyle = AppTextStyles.bodyMedium;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesBloc, PackagesState>(
      bloc: _packagesBloc,
      builder: (context, state) {
        if (state.currentPkg.state == Result.loading) {
          return SizedBox();
        }

        pkg = state.currentPkg.data!;
        return Scaffold(
          appBar: PrimaryAppBar(
            title: "package_detail".tr(),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.printer_fill),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.smallSpacing,
              vertical: AppDimensions.largeSpacing,
            ),
            child: Column(
              children: [
                PrimaryCard(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PrimaryText(
                          "pkg_info".tr(),
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      _buildInfoField(title: "pkg_code".tr(), value: pkg.id),
                      _buildInfoField(
                        title: "shipper_code".tr(),
                        value: pkg.shipperId,
                      ),
                      _buildInfoField(
                        title: "created_at".tr(),
                        value: DateTimeUtils.formatDateFromDT(pkg.createdAt),
                      ),
                      _buildInfoField(
                        title: "updated_at".tr(),
                        value: DateTimeUtils.formatDateFromDT(pkg.updatedAt),
                      ),
                      _buildInfoField(
                        title: "pkg_status".tr(),
                        value: pkg.status,
                      ),
                      _buildInfoField(
                        title: "distance".tr(),
                        value: pkg.distance?.toString(),
                      ),
                      _buildInfoField(
                        title: "est_time".tr(),
                        value: pkg.duration?.toString(),
                      ),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryCard(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PrimaryText(
                          "shop_info".tr(),
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      _buildInfoField(
                        title: "shop_name".tr(),
                        value: pkg.shopId,
                      ),
                      _buildInfoField(
                        title: "phone_number".tr(),
                        value: pkg.shopPhone,
                      ),
                      _buildInfoField(title: "address".tr(), value: null),
                    ],
                  ),
                ),
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryCard(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PrimaryText(
                          "orders_list".tr(),
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pkg.orders.length,
                        itemBuilder:
                            (context, index) => OrderOfPkgInfoItem(
                              index: index,
                              order: pkg.orders[index],
                            ),
                        separatorBuilder:
                            (_, __) => const Divider(
                              height: AppDimensions.xLargeSpacing,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoField({required String title, required String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xxSmallSpacing,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText("$title: "),
          Expanded(
            child: PrimaryText(
              value,
              style: _valueStyle,
              bold: true,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
