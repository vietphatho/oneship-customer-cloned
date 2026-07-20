import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/repositories/shop_repository.dart';

@lazySingleton
class FetchMobilePostsUseCase {
  FetchMobilePostsUseCase(this._repository);

  final ShopRepository _repository;

  Future<Resource<PromotionsPageEntity>> call({
    required MobilePostCategory category,
    required int page,
    int perPage = 5,
  }) {
    return _repository.fetchMobilePosts(
      category: category,
      page: page,
      perPage: perPage,
    );
  }
}
