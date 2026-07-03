import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/order_option_response.dart';

part 'order_option_entity.freezed.dart';

@freezed
abstract class OrderOptionEntity with _$OrderOptionEntity {
  const factory OrderOptionEntity({
    @Default("") String code,
    @Default("") String name,
  }) = _OrderOptionEntity;

  factory OrderOptionEntity.fromCommodity(CommodityResponse dto) {
    return OrderOptionEntity(code: dto.code ?? "", name: dto.name ?? "");
  }

  factory OrderOptionEntity.fromHandling(HandlingResponse dto) {
    return OrderOptionEntity(code: dto.code ?? "", name: dto.name ?? "");
  }
}

extension OrderOptionListX on List<OrderOptionEntity> {
  List<OrderOptionEntity> findByCodes(List<String> codes) {
    final optionsByCode = <String, OrderOptionEntity>{
      for (final option in this) option.code: option,
    };

    return codes
        .map((code) => optionsByCode[code])
        .whereType<OrderOptionEntity>()
        .toList();
  }

  String displayNamesForCodes(List<String> codes) {
    return findByCodes(
      codes,
    ).map((option) => option.name).where((name) => name.isNotEmpty).join(", ");
  }
}
