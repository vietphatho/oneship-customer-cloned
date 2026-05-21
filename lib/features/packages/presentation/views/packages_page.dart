import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/packages/presentation/widgets/package_item.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final PackagesBloc _packagesBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    var currentShop = _shopBloc.state.currentShop;
    if (currentShop != null && _packagesBloc.state.pkgsData.isEmpty) {
      _packagesBloc.init(currentShop);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "packages".tr()),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen: (pre, cur) => pre.currentPkg != cur.currentPkg,
            listener: _handleCurrentPkgChanged,
          ),
          BlocListener<PackagesBloc, PackagesState>(
            bloc: _packagesBloc,
            listenWhen:
                (pre, cur) => pre.pkgsDataResource != cur.pkgsDataResource,
            listener: _handleRefreshablePkgs,
          ),
        ],
        child: BlocBuilder<PackagesBloc, PackagesState>(
          bloc: _packagesBloc,
          buildWhen:
              (previous, current) => previous.pkgsData != current.pkgsData,
          builder: (context, state) {
            var data = state.pkgsData;

            if (data.isEmpty) {
              return const PrimaryEmptyData();
            }

            return PrimaryRefreshabelListView(
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              enablePullUp: true,
              itemBuilder:
                  (context, index) => PackageItem(
                    index: index,
                    package: data[index],
                    onViewDetail: onViewDetail,
                  ),
              itemCount: data.length,
              separatorBuilder:
                  (context, index) =>
                      const SizedBox(height: AppDimensions.smallSpacing),
            );
          },
        ),
      ),
    );
  }

  void onViewDetail(Package pkg) {
    _packagesBloc.viewPkg(pkg.id);
  }

  void _handleCurrentPkgChanged(BuildContext context, PackagesState state) {
    switch (state.currentPkg.state) {
      case Result.loading:
        PrimaryDialog.showLoadingDialog(context);
        break;
      case Result.success:
        PrimaryDialog.hideLoadingDialog(context);
        context.push(RouteName.packageDetailPage);
        break;
      case Result.error:
        PrimaryDialog.hideLoadingDialog(context);
        PrimaryDialog.showErrorDialog(
          context,
          message: state.currentPkg.message,
        );
        break;
    }
  }

  void _handleRefreshablePkgs(BuildContext context, PackagesState state) {
    switch (state.pkgsDataResource.state) {
      case Result.success:
        _refreshController
          ..refreshCompleted()
          ..loadComplete();
        break;
      case Result.error:
        _refreshController
          ..refreshFailed()
          ..loadFailed();
      default:
    }
  }

  void _onRefresh() {
    _packagesBloc.fetchPackages();
  }

  void _onLoading() {
    if (_packagesBloc.state.meta?.hasNext == false) {
      _refreshController.loadNoData();
      return;
    }

    _packagesBloc.loadMorePackages();
  }
}
