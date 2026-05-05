import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_multi_orders_state.freezed.dart';

@freezed
abstract class CreateMultiOrdersState with _$CreateMultiOrdersState {
  factory CreateMultiOrdersState({
    @Default("") String filePath,
  }) = _CreateMultiOrdersState;
}