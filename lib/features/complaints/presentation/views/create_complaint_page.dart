import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_customer/core/base/components/primary_app_bar.dart';
import 'package:oneship_customer/core/base/components/primary_text_field.dart';
import 'package:oneship_customer/core/base/components/primary_button.dart';
import 'package:oneship_customer/core/base/components/primary_dropdown.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/themes/app_colors.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/create_complaint_bloc.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/create_complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/create_complaint_state.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:go_router/go_router.dart';

// Các hằng số cấu hình form — đặt ở cấp file, không đặt trong State
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

  String _selectedCategory = _kCategories.first;
  String _selectedPriority = _kPriorities.first;

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceIdController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _referenceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateComplaintBloc>(),
      child: BlocListener<CreateComplaintBloc, CreateComplaintState>(
        listenWhen: (prev, curr) => curr.createResource.state != prev.createResource.state,
        listener: (context, state) {
          if (state.createResource.state == Result.success && state.createResource.data != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('complaints.create_success'.tr())),
            );
            context.pop(true);
          } else if (state.createResource.state == Result.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.createResource.message.isNotEmpty
                  ? state.createResource.message
                  : 'complaints.create_error'.tr())),
            );
          }
        },
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
                    validator: (val) => (val == null || val.isEmpty) ? 'complaints.validation_required'.tr() : null,
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
                    validator: (val) => (val == null || val.isEmpty) ? 'complaints.validation_required'.tr() : null,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<CreateComplaintBloc, CreateComplaintState>(
                    builder: (context, state) {
                      final isLoading = state.createResource.state == Result.loading;
                      return PrimaryButton.filled(
                        label: 'complaints.submit'.tr(),
                        onPressed: isLoading ? null : _onSubmit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<CreateComplaintBloc>().add(
          CreateComplaintEvent.submitted(
            category: _selectedCategory,
            priority: _selectedPriority,
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            referenceType: _kDefaultReferenceType,
            referenceId: _referenceIdController.text.trim(),
          ),
        );
  }
}
