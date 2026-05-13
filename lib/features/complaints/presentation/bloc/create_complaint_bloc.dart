import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/create_complaint_use_case.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/create_complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/create_complaint_state.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

@injectable
class CreateComplaintBloc extends Bloc<CreateComplaintEvent, CreateComplaintState> {
  final CreateComplaintUseCase _createComplaintUseCase;
  final ShopBloc _shopBloc;

  CreateComplaintBloc(
    this._createComplaintUseCase,
    this._shopBloc,
  ) : super(CreateComplaintState.initial()) {
    on<CreateComplaintSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onSubmitted(
    CreateComplaintSubmitted event,
    Emitter<CreateComplaintState> emit,
  ) async {
    final shopId = _shopBloc.state.currentShop?.shopId;
    if (shopId == null) return;

    emit(state.copyWith(createResource: Resource.loading()));
    
    final response = await _createComplaintUseCase.call(
      category: event.category,
      priority: event.priority,
      subject: event.subject,
      description: event.description,
      referenceType: event.referenceType,
      referenceId: event.referenceId,
      shopId: shopId,
    );

    emit(state.copyWith(createResource: response));
  }
}
