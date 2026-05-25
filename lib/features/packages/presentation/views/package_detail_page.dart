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
  final ScrollController _scrollController = ScrollController();

  late PackageDetail pkg;

  TextStyle _valueStyle = AppTextStyles.bodyMedium;

  int _currentLimit = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (pkg.orders.length > _currentLimit) {
          setState(() {
            _currentLimit += 10;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackagesBloc, PackagesState>(
      bloc: _packagesBloc,
      builder: (context, state) {
        if (state.currentPkg.state == Result.loading) {
          return SizedBox();
        }

        pkg = state.currentPkg.data!;
        int displayCount = pkg.orders.length;
        bool hasMore = displayCount > _currentLimit;
        int listCount = hasMore ? _currentLimit : displayCount;

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
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.smallSpacing,
                  AppDimensions.largeSpacing,
                  AppDimensions.smallSpacing,
                  0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
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
                            value: pkg.status?.tr(),
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
                            value: pkg.shopName ?? pkg.shopId,
                          ),
                          _buildInfoField(
                            title: "phone_number".tr(),
                            value: pkg.shopPhone,
                          ),
                          _buildInfoField(title: "address".tr(), value: pkg.shopAddress),
                        ],
                      ),
                    ),
                    AppSpacing.vertical(AppDimensions.mediumSpacing),
                    PrimaryCard(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PrimaryText(
                          "orders_list".tr(),
                          style: AppTextStyles.titleLarge,
                        ),
                      ),
                    ),
                    AppSpacing.vertical(AppDimensions.smallSpacing),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.smallSpacing,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return const Divider(height: AppDimensions.xLargeSpacing);
                      }
                      final orderIndex = index ~/ 2;
                      return OrderOfPkgInfoItem(
                        index: orderIndex,
                        order: pkg.orders[orderIndex],
                      );
                    },
                    childCount: listCount > 0 ? listCount * 2 - 1 : 0,
                  ),
                ),
              ),
              if (hasMore)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.mediumSpacing),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              const SliverPadding(padding: EdgeInsets.only(bottom: AppDimensions.largeSpacing)),
            ],
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
