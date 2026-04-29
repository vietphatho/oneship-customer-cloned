import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_check_box.dart';
import 'package:oneship_customer/core/base/components/primary_dialog.dart';
import 'package:oneship_customer/core/base/components/secondary_button.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/constants/svg_path.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/domain/entities/product_entity.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';

enum ProductOverlayType { create, select }

class ProductSelectionButton extends StatefulWidget {
  const ProductSelectionButton({super.key});

  @override
  State<ProductSelectionButton> createState() => _ProductSelectionButtonState();
}

class _ProductSelectionButtonState extends State<ProductSelectionButton> {
  final ProductBloc _productBloc = getIt.get();

  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  ProductOverlayType currentOverlay = ProductOverlayType.select;

  OverlayEntry _createProductOverlay() {
    return OverlayEntry(
      builder:
          (context) => StatefulBuilder(
            builder: (context, setStateOverlay) {
              Widget child;

              if (currentOverlay == ProductOverlayType.create) {
                child = _CreateProductContainer(
                  onSwitch: () {
                    setStateOverlay(() {
                      currentOverlay = ProductOverlayType.select;
                    });
                  },
                  onClose: _closeProductOverlay,
                );
              } else {
                child = _SelectProductContainer(
                  onSwitch: () {
                    setStateOverlay(() {
                      currentOverlay = ProductOverlayType.create;
                    });
                  },
                  onClose: _closeProductOverlay,
                );
              }

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                    },
                    child: Container(color: Colors.transparent),
                  ),
                  Positioned(
                    width:
                        MediaQuery.of(context).size.width -
                        2 * AppDimensions.mediumSpacing,
                    child: CompositedTransformFollower(
                      link: _layerLink,
                      offset: const Offset(0, 14),
                      targetAnchor: Alignment.bottomLeft,
                      followerAnchor: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: AppDimensions.mediumBorderRadius,
                        color: Colors.transparent,
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _openProductOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createProductOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _closeProductOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _openProductOverlay,
        child: AbsorbPointer(
          child: PrimaryTextField(
            label: "product".tr(),
            suffixIcon: Icon(
              Icons.add_circle,
              size: 24,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectProductContainer extends StatefulWidget {
  final VoidCallback onSwitch;
  final VoidCallback onClose;

  const _SelectProductContainer({
    required this.onSwitch,
    required this.onClose,
  });

  @override
  State<_SelectProductContainer> createState() =>
      _SelectProductContainerState();
}

class _SelectProductContainerState extends State<_SelectProductContainer> {
  final ProductBloc _productBloc = getIt.get();
  final CreateOrderBloc _createOrderBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.mediumSpacing),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: AppDimensions.mediumBorderRadius,
        border: Border.all(width: 1.5, color: AppColors.neutral7),
      ),
      child: Column(
        children: [
          Row(
            children: [
              PrimaryText(
                "select_product".tr(),
                style: AppTextStyles.titleMedium,
              ),
              Spacer(),
              _CreateProductButton(
                label: "create_new".tr(),
                onPressed: widget.onSwitch,
              ),
            ],
          ),
          AppSpacing.vertical(AppDimensions.xxLargeSpacing),

          BlocConsumer<ProductBloc, ProductState>(
            bloc: _productBloc,
            listener: (context, state) {
              switch (state.products!.state) {
                case Result.loading:
                  PrimaryDialog.showLoadingDialog(context);
                  break;
                case Result.success:
                  PrimaryDialog.hideLoadingDialog(context);
                  break;
                case Result.error:
                  PrimaryDialog.hideLoadingDialog(context);
                  PrimaryDialog.showErrorDialog(context);
                  break;
              }
            },
            builder: (context, state) {
              if (state.products?.data != null) {
                if (state.products!.data!.isNotEmpty) {
                  return Column(
                    children: [
                      PrimaryTextField(),
                      AppSpacing.vertical(AppDimensions.smallSpacing),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: PrimaryText(
                              "sku_code".tr(),
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: PrimaryText(
                              "price".tr(),
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: PrimaryText(
                                "select".tr(),
                                style: AppTextStyles.titleSmall,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state.products!.data!.length,
                          itemBuilder: (context, index) {
                            final product = state.products!.data![index];
                            return _productSelectionItem(product);
                          },
                        ),
                      ),
                    ],
                  );
                }
              }

              return Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      SvgPath.iconEmptyProduct,
                      width: 50,
                      height: 50,
                    ),
                  ),

                  AppSpacing.vertical(AppDimensions.smallSpacing),

                  Align(
                    alignment: Alignment.center,
                    child: PrimaryText(
                      "dont_have_product".tr(),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              );
            },
          ),

          AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocSelector<ProductBloc, ProductState, int>(
                bloc: _productBloc,
                selector: (state) {
                  return state.selectedCount;
                },
                builder: (context, selectedCount) {
                  return PrimaryText(
                    "$selectedCount ${"product_selected".tr()}",
                    style: AppTextStyles.labelMedium,
                  );
                },
              ),
              SizedBox(
                width: 72,
                child: SecondaryButton.filled(
                  onPressed: () {
                    _createOrderBloc.addProductToOrder(
                      _productBloc.state.getSelectedProducts(),
                    );
                    _productBloc.resetProductSelected();
                    widget.onClose();
                  },
                  label: "done".tr(),
                  height: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productSelectionItem(ProductEntity product) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(product.productName, style: AppTextStyles.bodyMedium),
              PrimaryText(product.skuCode, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: PrimaryText(
            Utils.formatCurrencyWithUnit(product.price),
            style: AppTextStyles.bodyMedium,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: PrimaryCheckBox(
              value: product.isSelected,
              onChanged: (value) {
                _productBloc.toggleProductSelection(product.skuCode);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateProductContainer extends StatefulWidget {
  final VoidCallback onSwitch;
  final VoidCallback onClose;
  const _CreateProductContainer({
    required this.onSwitch,
    required this.onClose,
  });

  @override
  State<_CreateProductContainer> createState() =>
      _CreateProductContainerState();
}

class _CreateProductContainerState extends State<_CreateProductContainer> {
  final ProductBloc _productBloc = getIt.get();

  final TextEditingController _proNameCtrl = TextEditingController();
  final TextEditingController _skuCodeCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      bloc: _productBloc,
      listener: (context, state) {
        switch (state.products!.state) {
          case Result.loading:
            PrimaryDialog.showLoadingDialog(context);
            break;
          case Result.success:
            PrimaryDialog.hideLoadingDialog(context);
            widget.onSwitch();
            break;
          case Result.error:
            PrimaryDialog.hideLoadingDialog(context);
            PrimaryDialog.showErrorDialog(context);
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.mediumSpacing),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: AppDimensions.mediumBorderRadius,
          border: Border.all(color: AppColors.neutral7, width: 1.5),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  PrimaryText(
                    "create_new_product".tr(),
                    style: AppTextStyles.titleMedium,
                  ),
                  Spacer(),
                  _CreateProductButton(
                    label: "list".tr(),
                    onPressed: widget.onSwitch,
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryTextField(
                label: "product_name".tr(),
                isRequired: true,
                controller: _proNameCtrl,
                validator: Validators.validateEmptyField,
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextField(
                      label: "sku_code".tr(),
                      isRequired: true,
                      controller: _skuCodeCtrl,
                      validator: Validators.validateEmptyField,
                    ),
                  ),
                  AppSpacing.horizontal(AppDimensions.smallSpacing),
                  Expanded(
                    child: PrimaryTextField(
                      label: "price".tr(),
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      controller: _priceCtrl,
                      validator: Validators.validateEmptyField,
                    ),
                  ),
                ],
              ),
              AppSpacing.vertical(AppDimensions.smallSpacing),
              PrimaryButton.filled(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _productBloc.createNewProduct(
                      ProductEntity(
                        productName: _proNameCtrl.text.trim(),
                        skuCode: _skuCodeCtrl.text.trim(),
                        price: int.parse(_priceCtrl.text.trim()),
                        isSelected: true,
                      ),
                    );
                  }
                },
                label: "create_and_add_to_order".tr(),
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _proNameCtrl.dispose();
    _skuCodeCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }
}

class _CreateProductButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _CreateProductButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, 0),
        side: const BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, size: 24, color: AppColors.primary),
          AppSpacing.horizontal(AppDimensions.xSmallSpacing),
          PrimaryText(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
