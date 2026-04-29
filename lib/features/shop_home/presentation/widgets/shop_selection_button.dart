import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopSelectionButton extends StatelessWidget {
  const ShopSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen:
          (previous, current) =>
              previous.shopsResource != current.shopsResource ||
              previous.currentShop != current.currentShop,
      builder: (context, state) {
        final shops = state.shopsResource.data?.data ?? const [];
        if (shops.isEmpty || state.currentShop == null) {
          return const SizedBox.shrink();
        }

        final selectedShop =
            shops.contains(state.currentShop) ? state.currentShop : null;

        return _ShopDropdownButton<ShopEntity>(
          items: shops,
          value: selectedShop,
          labelBuilder: (shop) => shop.shopName,
          onChanged: (value) {
            if (value != null) {
              shopBloc.changeShop(value);
            }
          },
        );
      },
    );
  }
}

class _ShopDropdownButton<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;

  final EdgeInsets padding;
  final Color backgroundColor;
  final double iconSize;
  final Color iconColor;
  final double borderRadius;

  const _ShopDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.labelBuilder,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimensions.smallSpacing,
      vertical: AppDimensions.xSmallSpacing,
    ),
    this.backgroundColor = Colors.white,
    this.iconSize = AppDimensions.xSmallIconSize,
    this.iconColor = AppColors.neutral5,
    this.borderRadius = AppDimensions.largeRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        // border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: iconSize,
            color: iconColor,
          ),
          items:
              items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: PrimaryText(
                    labelBuilder(item),
                    style: AppTextStyles.labelSmall,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
