import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_frame.dart';
import 'package:oneship_customer/core/utils/validators.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_bloc.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/orders/presentation/views/confirmation_info_page_view.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_bottom_bar.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_delivery_service_selector.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_receiver_section.dart';
import 'package:oneship_customer/features/orders/presentation/widgets/create_order_surcharge_section.dart';

class HospitalCreateOrderFormPage extends StatelessWidget {
  const HospitalCreateOrderFormPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _HospitalCreateOrderForm(),
        SizedBox.shrink(),
        ConfirmationInfoPageView(),
      ],
    );
  }
}

class _HospitalCreateOrderForm extends StatefulWidget {
  const _HospitalCreateOrderForm();

  @override
  State<_HospitalCreateOrderForm> createState() =>
      _HospitalCreateOrderFormState();
}

class _HospitalCreateOrderFormState extends State<_HospitalCreateOrderForm> {
  final CreateOrderBloc _createOrderBloc = getIt.get();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _medicalRecordCodeCtrl = TextEditingController();
  final TextEditingController _prescriptionNumberCtrl = TextEditingController();
  final TextEditingController _delegateNameCtrl = TextEditingController();
  final TextEditingController _delegatePhoneCtrl = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final request = _createOrderBloc.state.request;
    _nameCtrl.text = request.customerName ?? "";
    _phoneCtrl.text = request.phone ?? "";
    _addressCtrl.text = request.fullAddress ?? "";
    _medicalRecordCodeCtrl.text =
        request.hospitalMetadata?.medicalRecordCode ?? "";
    _prescriptionNumberCtrl.text =
        request.hospitalMetadata?.prescriptionNumber ?? "";
    _delegateNameCtrl.text = request.hospitalMetadata?.delegateName ?? "";
    _delegatePhoneCtrl.text = request.hospitalMetadata?.delegatePhone ?? "";
    _noteController.text = request.detail?.note ?? "";
    _createOrderBloc.applyHospitalCreateOrderDefaults();
    _createOrderBloc.init();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _medicalRecordCodeCtrl.dispose();
    _prescriptionNumberCtrl.dispose();
    _delegateNameCtrl.dispose();
    _delegatePhoneCtrl.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderBloc, CreateOrderState>(
      bloc: _createOrderBloc,
      builder: (context, state) {
        return ColoredBox(
          color: AppColors.neutral9,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.xSmallSpacing),
                  child: Column(
                    children: [
                      _section(
                        title: "hospital_patient_info".tr(),
                        child: Column(
                          children: [
                            CreateOrderReceiverSection(
                              nameController: _nameCtrl,
                              phoneController: _phoneCtrl,
                              addressController: _addressCtrl,
                              onChanged: _refresh,
                            ),
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            PrimaryTextField(
                              label: "medical_record_code".tr(),
                              isRequired: true,
                              controller: _medicalRecordCodeCtrl,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => _refresh(),
                            ),
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            PrimaryTextField(
                              label: "prescription_number".tr(),
                              isRequired: true,
                              controller: _prescriptionNumberCtrl,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => _refresh(),
                            ),
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            PrimaryTextField(
                              label: "note".tr(),
                              hintText: "note_hint".tr(),
                              controller: _noteController,
                              maxLength: 200,
                              maxLine: 2,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _section(
                        title: "additional_info".tr(),
                        child: Column(
                          children: [
                            PrimaryTextField(
                              label: "delegate_name".tr(),
                              controller: _delegateNameCtrl,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => _refresh(),
                            ),
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            PrimaryTextField(
                              label: "delegate_phone".tr(),
                              controller: _delegatePhoneCtrl,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (_) => _refresh(),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vertical(AppDimensions.xSmallSpacing),
                      _section(
                        title: "hospital_service_info".tr(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CreateOrderDeliveryServiceSelector(
                              firstServiceOnly: true,
                              lockSelection: true,
                            ),
                            AppSpacing.vertical(AppDimensions.smallSpacing),
                            const CreateOrderSurchargeSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CreateOrderBottomBar(
                onContinue: _isValid(state) ? _onNext : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section({required String title, required Widget child}) {
    return PrimaryFrame(
      padding: const EdgeInsets.all(AppDimensions.smallSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryText(
            title,
            style: AppTextStyles.labelLarge,
            color: AppColors.primary,
            bold: true,
          ),
          AppSpacing.vertical(AppDimensions.smallSpacing),
          child,
        ],
      ),
    );
  }

  void _refresh() => setState(() {});

  bool _isValid(CreateOrderState state) {
    final hasValidPhone =
        Validators.validatePhoneNumber(_phoneCtrl.text.trim()) == null;
    return _nameCtrl.text.trim().isNotEmpty &&
        hasValidPhone &&
        _addressCtrl.text.trim().isNotEmpty &&
        state.draftRequest.province != null &&
        state.draftRequest.ward != null &&
        state.draftRequest.serviceConfig != null &&
        _medicalRecordCodeCtrl.text.trim().isNotEmpty &&
        _prescriptionNumberCtrl.text.trim().isNotEmpty;
  }

  void _onNext() {
    _createOrderBloc.completeHospitalCreateOrderForm(
      customerName: _nameCtrl.text,
      phoneNumber: _phoneCtrl.text,
      address: _addressCtrl.text,
      medicalRecordCode: _medicalRecordCodeCtrl.text,
      prescriptionNumber: _prescriptionNumberCtrl.text,
      delegateName: _delegateNameCtrl.text,
      delegatePhone: _delegatePhoneCtrl.text,
      note: _noteController.text,
    );
  }
}
