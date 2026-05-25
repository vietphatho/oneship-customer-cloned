import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/complaints/domain/use_cases/create_complaint_use_case.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_event.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/create_complaint_state.dart';

@injectable
class CreateComplaintBloc extends Bloc<CreateComplaintEvent, CreateComplaintState> {
  final CreateComplaintUseCase _createComplaintUseCase;

  CreateComplaintBloc(
    this._createComplaintUseCase,
  ) : super(CreateComplaintState.initial()) {
    on<CreateComplaintSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onSubmitted(
    CreateComplaintSubmitted event,
    Emitter<CreateComplaintState> emit,
  ) async {
    emit(state.copyWith(createResource: Resource.loading()));

    final response = await _createComplaintUseCase.call(
      category: event.category,
      priority: event.priority,
      subject: event.subject,
      description: event.description,
      referenceType: event.referenceType,
      referenceId: event.referenceId,
      shopId: event.shopId,
    );

    emit(state.copyWith(createResource: response));
  }

  void submit({
    required String category,
    required String priority,
    required String subject,
    required String description,
    required String referenceType,
    required String referenceId,
    required String shopId,
  }) {
    add(CreateComplaintSubmitted(
      category: category,
      priority: priority,
      subject: subject,
      description: description,
      referenceType: referenceType,
      referenceId: referenceId,
      shopId: shopId,
    ));
  }
}
