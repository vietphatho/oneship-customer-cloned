import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_bloc.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_state.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/bloc/vendor_orders_tab.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/widgets/vendor_order_search_box.dart';
import 'package:oneship_customer/features/vendor/orders/presentation/widgets/vendor_orders_list.dart';

class VendorOrdersTabBody extends StatelessWidget {
  const VendorOrdersTabBody({super.key, required this.tab});

  final VendorOrdersTab tab;

  @override
  Widget build(BuildContext context) {
    final bloc = getIt.get<VendorOrdersBloc>();

    return BlocBuilder<VendorOrdersBloc, VendorOrdersState>(
      bloc: bloc,
      buildWhen: (previous, current) {
        return switch (tab) {
          VendorOrdersTab.processing =>
            previous.processingOrdersResource !=
                    current.processingOrdersResource ||
                previous.processingKeyword != current.processingKeyword,
          VendorOrdersTab.archived =>
            previous.archivedOrdersResource != current.archivedOrdersResource ||
                previous.archivedKeyword != current.archivedKeyword,
        };
      },
      builder: (context, state) {
        final keyword = switch (tab) {
          VendorOrdersTab.processing => state.processingKeyword,
          VendorOrdersTab.archived => state.archivedKeyword,
        };

        return Column(
          children: [
            VendorOrderSearchBox(
              keyword: keyword,
              onChanged: (value) => switch (tab) {
                VendorOrdersTab.processing => bloc.searchProcessingOrders(
                  value,
                ),
                VendorOrdersTab.archived => bloc.searchArchivedOrders(value),
              },
            ),
            AppSpacing.vertical(AppDimensions.smallSpacing),
            Expanded(child: VendorOrdersList(tab: tab)),
          ],
        );
      },
    );
  }
}
