import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/delete_complaint_use_case.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/get_complaints_use_case.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/features/complaints/domain/entities/complaint_entity.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_customer/features/complaints/presentation/bloc/complaint_state.dart';
import 'package:oneship_customer/features/complaints/domain/use_cases/get_complaint_summary_use_case.dart';

@injectable
class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final GetComplaintsUseCase _getComplaintsUseCase;
  final DeleteComplaintUseCase _deleteComplaintUseCase;
  final GetComplaintSummaryUseCase _getComplaintSummaryUseCase;

  ComplaintBloc(
    this._getComplaintsUseCase,
    this._deleteComplaintUseCase,
    this._getComplaintSummaryUseCase,
  ) : super(ComplaintState.initial()) {
    on<ComplaintStarted>(_onStarted);
    on<ComplaintLoadMore>(_onLoadMore);
    on<ComplaintDeleted>(_onComplaintDeleted);
  }

  FutureOr<void> _onStarted(ComplaintStarted event, Emitter<ComplaintState> emit) async {
    emit(state.copyWith(
      selectedCategory: event.category,
      shopId: event.shopId,
      selectedStatus: event.status,
      page: 1,
      canLoadMore: true,
      complaintsResource: Resource.loading(),
      summaryResource: Resource.loading(),
    ));
    await Future.wait([
      _fetchComplaints(event.category, event.shopId, event.status, 1, emit, isRefresh: true),
      _fetchSummary(event.shopId, emit),
    ]);
  }

  FutureOr<void> _onLoadMore(ComplaintLoadMore event, Emitter<ComplaintState> emit) async {
    if (!state.canLoadMore || state.complaintsResource.state == Result.loading) return;
    final nextPage = state.page + 1;
    await _fetchComplaints(state.selectedCategory, state.shopId, state.selectedStatus, nextPage, emit, isRefresh: false);
  }

  FutureOr<void> _onComplaintDeleted(
    ComplaintDeleted event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(state.copyWith(deleteResource: Resource.loading()));
    final response = await _deleteComplaintUseCase.call(event.id);
    emit(state.copyWith(deleteResource: response));

    if (response.data == true) {
      await _fetchComplaints(state.selectedCategory, state.shopId, state.selectedStatus, 1, emit, isRefresh: true);
    }
  }

  Future<void> _fetchComplaints(String category, String? shopId, String? status, int page, Emitter<ComplaintState> emit, {bool isRefresh = true}) async {
    if (shopId == null) {
      emit(state.copyWith(complaintsResource: Resource.error('Shop ID is required', 0)));
      return;
    }
    
    final response = await _getComplaintsUseCase.call(
      category: category,
      shopId: shopId,
      status: status,
      page: page,
      limit: 10,
    );
    
    if (response.state == Result.success) {
      final newItems = response.data ?? [];
      final existingItems = isRefresh ? <ComplaintEntity>[] : (state.complaintsResource.data ?? <ComplaintEntity>[]);
      final allItems = [...existingItems, ...newItems];
      emit(state.copyWith(
        page: page,
        canLoadMore: newItems.isNotEmpty && newItems.length >= 10,
        complaintsResource: Resource.success(allItems),
      ));
    } else if (isRefresh) {
      emit(state.copyWith(complaintsResource: response));
    } else {
      emit(state.copyWith());
    }
  }


  Future<void> _fetchSummary(String? shopId, Emitter<ComplaintState> emit) async {
    if (shopId == null) {
      emit(state.copyWith(summaryResource: Resource.error('Shop ID is required', 0)));
      return;
    }
    try {
      final response = await _getComplaintSummaryUseCase.call(shopId: shopId);
      emit(state.copyWith(summaryResource: response));
    } catch (e) {
      emit(state.copyWith(summaryResource: Resource.error(e.toString(), 0)));
    }
  }

  void fetchComplaints() {
    add(ComplaintStarted(
      category: state.selectedCategory,
      shopId: state.shopId,
      status: state.selectedStatus,
    ));
  }

  void deleteComplaint(String id) {
    add(ComplaintDeleted(id: id));
  }
}
