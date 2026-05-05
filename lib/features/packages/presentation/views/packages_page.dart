import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/packages/data/models/response/packages_list_response.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:oneship_customer/features/packages/presentation/bloc/packages_state.dart';
import 'package:oneship_customer/features/packages/presentation/widgets/package_item.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final PackagesBloc _packagesBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  @override
  void initState() {
    super.initState();
    var currentShop = _shopBloc.state.currentShop;
    if (currentShop != null) {
      _packagesBloc.init(currentShop);
    }
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
        ],
        child: BlocBuilder<PackagesBloc, PackagesState>(
          bloc: _packagesBloc,
          builder: (context, state) {
            if (_packagesBloc.packages.isEmpty) {
              return const PrimaryEmptyData();
            }

            return ListView.separated(
              itemCount: _packagesBloc.packages.length,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.mediumSpacing,
              ),
              itemBuilder:
                  (context, index) => PackageItem(
                    index: index,
                    package: _packagesBloc.packages[index],
                    onViewDetail: onViewDetail,
                  ),
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
}
