import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_line_chart.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_summary_stats.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/wallet_bank_account.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_event.dart';

import 'package:oneship_customer/di/injection_container.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _walletBloc = getIt<WalletBloc>();

  @override
  void initState() {
    super.initState();
    _walletBloc.add(FetchWalletDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral9,
      appBar: PrimaryAppBar(
        title: 'Ví của tôi',
        leading: BackButton(
          onPressed: () {
            getIt<ShopMasterBloc>().add(ShopMasterChangeMenuTabEvent(BottomNavigationItem.home));
            context.go(RouteName.shopMasterPage);
          },
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/transaction_history.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
            onPressed: () {
              // TODO: Navigate to transaction history
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        bloc: _walletBloc,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: PrimaryText(state.error!, color: Colors.red));
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              16.0 + AppDimensions.safeBottomSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WalletBalanceCard(balance: state.availableBalance),
                const SizedBox(height: 24),
                const WalletLineChart(),
                const SizedBox(height: 16),
                WalletSummaryStats(
                  totalWithdrawn: state.totalWithdrawn,
                  lastWithdrawnAmount: state.lastWithdrawnAmount,
                  lastWithdrawnDate: state.lastWithdrawnDate,
                ),
                const SizedBox(height: 24),
                const WalletBankAccount(),
              ],
            ),
          );
        },
      ),
    );
  }
}


