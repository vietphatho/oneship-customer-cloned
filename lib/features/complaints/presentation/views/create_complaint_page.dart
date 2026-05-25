import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_shop/core/base/components/primary_app_bar.dart';
import 'package:oneship_shop/core/base/components/primary_text_field.dart';
import 'package:oneship_shop/core/base/components/primary_dropdown.dart';
import 'package:oneship_shop/core/base/constants/enum.dart';
import 'package:oneship_shop/core/themes/app_colors.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_bloc.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_state.dart';
import 'package:oneship_shop/di/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_shop/core/utils/validators.dart';
import 'package:oneship_shop/features/complaints/presentation/widgets/submit_complaint_button.dart';
import 'package:oneship_shop/core/base/components/primary_dialog.dart';

import 'package:oneship_shop/features/shop_home/presentation/bloc/shop_bloc.dart';


const _kCategories = ['order_issue', 'delivery_issue'];
const _kPriorities = ['low', 'medium', 'high'];
const _kDefaultReferenceType = 'order';

class CreateComplaintPage extends StatefulWidget {
  const CreateComplaintPage({super.key});

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final CreateComplaintBloc _createComplaintBloc = getIt.get();
  final ShopBloc _shopBloc = getIt.get();

  String _selectedCategory = _kCategories.first;
  String _selectedPriority = _kPriorities.first;
  bool _isSubmitting = false;

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceIdController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _referenceIdController.dispose();
    _createComplaintBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateComplaintBloc, CreateComplaintState>(
      bloc: _createComplaintBloc,
      listenWhen: (prev, curr) => curr.createResource.state != prev.createResource.state,
      listener: _onStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: PrimaryAppBar(
          title: 'complaints.create_title'.tr(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryDropdown<String>(
                  label: 'complaints.category'.tr(),
                  isRequired: true,
                  initialValue: _selectedCategory,
                  menu: _kCategories,
                  toLabel: (item) => 'complaints.$item'.tr(),
                  onSelected: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 16),
                PrimaryDropdown<String>(
                  label: 'complaints.priority'.tr(),
                  isRequired: true,
                  initialValue: _selectedPriority,
                  menu: _kPriorities,
                  toLabel: (item) => 'complaints.priority_$item'.tr(),
                  onSelected: (val) => setState(() => _selectedPriority = val!),
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: 'complaints.title'.tr(),
                  isRequired: true,
                  controller: _subjectController,
                  hintText: 'complaints.subject_hint'.tr(),
                  validator: Validators.validateComplaintSubject,
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: 'complaints.reference_code'.tr(),
                  controller: _referenceIdController,
                  hintText: 'complaints.reference_id_hint'.tr(),
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: 'complaints.description'.tr(),
                  isRequired: true,
                  controller: _descriptionController,
                  hintText: 'complaints.description_hint'.tr(),
                  maxLine: 5,
                  validator: Validators.validateComplaintDescription,
                ),
                const SizedBox(height: 32),
                SubmitComplaintButton(
                  bloc: _createComplaintBloc,
                  isSubmitting: _isSubmitting,
                  onPressed: () => _onSubmit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, CreateComplaintState state) {
    if (state.createResource.state == Result.success && state.createResource.data != null) {
      setState(() => _isSubmitting = false);
      PrimaryDialog.showSuccessDialog(
        context,
        message: 'complaints.create_success'.tr(),
        onClosed: () {
          if (mounted) context.pop(true);
        },
      );
    } else if (state.createResource.state == Result.error) {
      setState(() => _isSubmitting = false);
      PrimaryDialog.showErrorDialog(
        context,
        message: state.createResource.message.isNotEmpty
            ? state.createResource.message
            : 'complaints.create_error'.tr(),
      );
    }
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final shopId = _shopBloc.state.currentShop?.shopId;
    if (shopId == null) return;

    setState(() => _isSubmitting = true);

    _createComplaintBloc.submit(
      category: _selectedCategory,
      priority: _selectedPriority,
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      referenceType: _kDefaultReferenceType,
      referenceId: _referenceIdController.text.trim(),
      shopId: shopId,
    );
  }
}
