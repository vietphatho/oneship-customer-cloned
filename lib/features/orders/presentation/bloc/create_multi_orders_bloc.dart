import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/create_multi_order_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_multi_orders_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_multi_orders_state.dart';

@lazySingleton
class CreateMultiOrdersBloc
    extends Bloc<CreateMultiOrdersEvent, CreateMultiOrdersState> {
  final CreateMultiOrderUseCase _createMultiOrderUseCase;
  CreateMultiOrdersBloc(this._createMultiOrderUseCase)
    : super(CreateMultiOrdersState()) {
    on<CreateMultiOrdersPickExcelFileEvent>(_onPickedExcelFile);
    on<CreateMultiOrdersCreateEvent>(_onCreatedMultiOrders);
  }

  FutureOr<void> _onPickedExcelFile(
    CreateMultiOrdersPickExcelFileEvent event,
    Emitter<CreateMultiOrdersState> emit,
  ) {
    emit(state.copyWith(filePath: event.filePath));
  }

  FutureOr<void> _onCreatedMultiOrders(
    CreateMultiOrdersCreateEvent event,
    Emitter<CreateMultiOrdersState> emit,
  ) {
    _createMultiOrderUseCase.call(filePath: state.filePath);
  }

  void createdMultiOrder() {
    add(CreateMultiOrdersCreateEvent());
  }

  void pickedExcelFile({required String filePath}) {
    add(CreateMultiOrdersPickExcelFileEvent(filePath: filePath));
  }
}
