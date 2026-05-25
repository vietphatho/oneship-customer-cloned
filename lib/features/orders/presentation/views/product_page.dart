import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:oneship_customer/features/orders/presentation/bloc/product_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/product_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductBloc _productBloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "select_product".tr(),
        actions: [
          IconButton(
            onPressed: _showCreateProductDialog,
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Padding(
        padding: AppDimensions.mediumPaddingAll,
        child: BlocBuilder<ProductBloc, ProductState>(
          bloc: _productBloc,
          buildWhen: (pre, cur) => pre.productsList != cur.productsList,
          builder: (context, state) {
            if (state.productsList.data != null) {
              if (state.productsList.data!.items!.isNotEmpty) {
                return Column(
                  children: [
                    // PrimaryTextField(),
                    // AppSpacing.vertical(AppDimensions.smallSpacing),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: PrimaryText(
                            "sku_code".tr(),
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: PrimaryText(
                            "price".tr(),
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: PrimaryText(
                              "select".tr(),
                              style: AppTextStyles.titleLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vertical(AppDimensions.smallSpacing),

                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: state.productsList.data!.items!.length,
                        itemBuilder: (context, index) {
                          final product =
                              state.productsList.data!.items![index];
                          return _productSelectionItem(product);
                        },
                      ),
                    ),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: BlocSelector<ProductBloc, ProductState, int>(
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
                          ),
                          AppSpacing.horizontal(AppDimensions.smallSpacing),
                          Expanded(
                            flex: 1,
                            child: SecondaryButton.filled(
                              onPressed: () {
                                context.pop();
                              },
                              label: "done".tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SvgPath.iconEmptyProduct,
                  width: AppDimensions.displayIconSize,
                  height: AppDimensions.displayIconSize,
                ),

                AppSpacing.vertical(AppDimensions.smallSpacing),

                PrimaryText(
                  "dont_have_product".tr(),
                  style: AppTextStyles.bodyMedium,
                ),

                AppSpacing.vertical(AppDimensions.xxxLargeSpacing),

                PrimaryButton.iconOutlined(
                  onPressed: _showCreateProductDialog,
                  label: 'create_new'.tr(),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCreateProductDialog() {
    PrimaryDialog.showCustomDialog(context, child: _CreateProductContainer());
  }

  Widget _productSelectionItem(ProductEntity product) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(product.name, style: AppTextStyles.bodyMedium),
              PrimaryText(product.sku, style: AppTextStyles.bodySmall),
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
            child: BlocBuilder<ProductBloc, ProductState>(
              bloc: _productBloc,
              buildWhen:
                  (pre, cur) =>
                      pre.productsListSelected != cur.productsListSelected,
              builder: (context, state) {
                return PrimaryCheckBox(
                  value: state.isSelected(product.sku),
                  onChanged: (value) {
                    if (value!) {
                      _productBloc.addToSelectedList(product);
                    } else {
                      _productBloc.removeFromSelectedList(product);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateProductContainer extends StatefulWidget {
  const _CreateProductContainer();

  @override
  State<_CreateProductContainer> createState() =>
      _CreateProductContainerState();
}

class _CreateProductContainerState extends State<_CreateProductContainer> {
  final ProductBloc _productBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  final TextEditingController _proNameCtrl = TextEditingController();
  final TextEditingController _skuCodeCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      bloc: _productBloc,
      listenWhen:
          (pre, cur) =>
              pre.createProductResource.state !=
              cur.createProductResource.state,
      listener: (context, state) {
        switch (state.createProductResource.state) {
          case Result.loading:
            PrimaryDialog.showLoadingDialog(context);
            break;
          case Result.success:
            PrimaryDialog.hideLoadingDialog(context);
            _productBloc.fetchProductsList(
              _shopBloc.state.currentShop?.shopId ?? "",
            );
            _productBloc.addToSelectedList(state.createProductResource.data!);
            context.pop();
            break;
          case Result.error:
            PrimaryDialog.hideLoadingDialog(context);
            PrimaryDialog.showErrorDialog(
              context,
              message: state.createProductResource.message,
            );
            break;
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryText(
              "create_new_product".tr(),
              style: AppTextStyles.titleLarge,
            ),
            AppSpacing.vertical(AppDimensions.largeSpacing),
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
                    inputFormatters: [_CurrencyTextInputFormatter()],
                    suffixText: Constants.currencyUnit,
                    validator: Validators.validateEmptyField,
                  ),
                ),
              ],
            ),
            AppSpacing.vertical(AppDimensions.xxLargeSpacing),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SecondaryButton.outlined(
                    onPressed: () {
                      context.pop();
                    },
                    label: "cancel".tr(),
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  flex: 2,
                  child: SecondaryButton.filled(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _productBloc.createProduct(
                          shopId: _shopBloc.state.currentShop?.shopId ?? "",
                          name: _proNameCtrl.text.trim(),
                          sku: _skuCodeCtrl.text.trim(),
                          price: Utils.parseCurrencyInput(_priceCtrl.text),
                        );
                      }
                    },
                    label: "create_and_add_to_order".tr(),
                  ),
                ),
              ],
            ),
          ],
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

class _CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final amount = Utils.parseCurrencyInput(newValue.text);
    if (amount == 0 && newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    final formatted = Utils.formatCurrencyInput(amount);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
