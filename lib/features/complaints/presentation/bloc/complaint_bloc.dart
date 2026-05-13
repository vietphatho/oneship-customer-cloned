import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/delete_complaint_use_case.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/get_complaints_use_case.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';

@injectable
class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final GetComplaintsUseCase _getComplaintsUseCase;
  final DeleteComplaintUseCase _deleteComplaintUseCase;
  final ShopBloc _shopBloc;

  ComplaintBloc(
    this._getComplaintsUseCase,
    this._deleteComplaintUseCase,
    this._shopBloc,
  ) : super(ComplaintState.initial()) {
    on<ComplaintStarted>(_onStarted);
    on<ComplaintDeleted>(_onComplaintDeleted);
  }

  FutureOr<void> _onStarted(ComplaintStarted event, Emitter<ComplaintState> emit) async {
    emit(state.copyWith(
      selectedCategory: event.category,
      complaintsResource: Resource.loading(),
    ));
    await _fetchComplaints(event.category, emit);
  }

  FutureOr<void> _onComplaintDeleted(
    ComplaintDeleted event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(state.copyWith(deleteResource: Resource.loading()));
    final response = await _deleteComplaintUseCase.call(event.id);
    emit(state.copyWith(deleteResource: response));

    if (response.data == true) {
      await _fetchComplaints(state.selectedCategory, emit);
    }
  }

  Future<void> _fetchComplaints(String category, Emitter<ComplaintState> emit) async {
    final shopId = _shopBloc.state.currentShop?.shopId;
    final response = await _getComplaintsUseCase.call(
      category: category,
      shopId: shopId,
    );
    emit(state.copyWith(complaintsResource: response));
  }

  // Public helper methods
  void fetchComplaints() {
    add(ComplaintEvent.started(category: state.selectedCategory));
  }

  void deleteComplaint(String id) {
    add(ComplaintEvent.complaintDeleted(id: id));
  }
}
