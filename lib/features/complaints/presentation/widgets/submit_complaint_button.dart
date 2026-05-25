import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:oneship_shop/core/base/components/primary_button.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_bloc.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_state.dart';

class SubmitComplaintButton extends StatelessWidget {
  final CreateComplaintBloc bloc;
  final bool isSubmitting;
  final VoidCallback? onPressed;

  const SubmitComplaintButton({
    super.key,
    required this.bloc,
    required this.isSubmitting,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateComplaintBloc, CreateComplaintState>(
      bloc: bloc,
      builder: (context, state) {
        return PrimaryButton.filled(
          label: 'complaints.submit'.tr(),
          onPressed: isSubmitting ? null : onPressed,
        );
      },
    );
  }
}
