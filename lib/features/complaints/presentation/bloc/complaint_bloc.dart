import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_shop/core/base/models/resource.dart';
import 'package:oneship_shop/features/complaints/domain/use_cases/delete_complaint_use_case.dart';
import 'package:oneship_shop/features/complaints/domain/use_cases/get_complaints_use_case.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/complaint_event.dart';
import 'package:oneship_shop/features/complaints/presentation/bloc/complaint_state.dart';

@injectable
class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final GetComplaintsUseCase _getComplaintsUseCase;
  final DeleteComplaintUseCase _deleteComplaintUseCase;

  ComplaintBloc(
    this._getComplaintsUseCase,
    this._deleteComplaintUseCase,
  ) : super(ComplaintState.initial()) {
    on<ComplaintStarted>(_onStarted);
    on<ComplaintDeleted>(_onComplaintDeleted);
  }

  FutureOr<void> _onStarted(ComplaintStarted event, Emitter<ComplaintState> emit) async {
    emit(state.copyWith(
      selectedCategory: event.category,
      shopId: event.shopId,
      complaintsResource: Resource.loading(),
    ));
    await _fetchComplaints(event.category, event.shopId, emit);
  }

  FutureOr<void> _onComplaintDeleted(
    ComplaintDeleted event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(state.copyWith(deleteResource: Resource.loading()));
    final response = await _deleteComplaintUseCase.call(event.id);
    emit(state.copyWith(deleteResource: response));

    if (response.data == true) {
      await _fetchComplaints(state.selectedCategory, state.shopId, emit);
    }
  }

  Future<void> _fetchComplaints(String category, String? shopId, Emitter<ComplaintState> emit) async {
    final response = await _getComplaintsUseCase.call(
      category: category,
      shopId: shopId,
    );
    emit(state.copyWith(complaintsResource: response));
  }


  void fetchComplaints() {
    add(ComplaintStarted(
      category: state.selectedCategory,
      shopId: state.shopId,
    ));
  }

  void deleteComplaint(String id) {
    add(ComplaintDeleted(id: id));
  }
}
