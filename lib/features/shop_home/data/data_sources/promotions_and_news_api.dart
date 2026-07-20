import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/data/models/response/promotions_program_response.dart';
import 'package:retrofit/retrofit.dart';

part 'promotions_and_news_api.g.dart';

@lazySingleton
@RestApi(baseUrl: PromotionsAndNewsApi.defaultBaseUrl)
abstract class PromotionsAndNewsApi {
  static const String defaultBaseUrl = 'https://ozoship.vn/wp-json/wp/v2';

  @factoryMethod
  factory PromotionsAndNewsApi(Dio dio) = _PromotionsAndNewsApi;

  @GET('/mobile-post')
  Future<HttpResponse<List<PromotionsProgramResponse>>> fetchMobilePosts({
    @Query('mobile-category') required int mobileCategory,
    @Query('orderby') String orderBy = 'date',
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 5,
    @Query('_embed') bool embed = true,
  });
}

extension PromotionsAndNewsApiX on PromotionsAndNewsApi {
  Future<HttpResponse<List<PromotionsProgramResponse>>> fetchByCategory({
    required MobilePostCategory category,
    int page = 1,
    int perPage = 5,
  }) {
    return fetchMobilePosts(
      mobileCategory: category.value,
      page: page,
      perPage: perPage,
    );
  }
}
