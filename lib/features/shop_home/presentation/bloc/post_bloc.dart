import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/use_cases/fetch_mobile_posts_use_case.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_event.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_state.dart';

@lazySingleton
class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(this._fetchMobilePostsUseCase)
    : super(
        PostState(
          promotionsResource: Resource.loading(),
          newsResource: Resource.loading(),
        ),
      ) {
    on<PostFetchHomePreviewEvent>(_onFetchHomePreview);
    on<PostFetchEvent>(_onFetch);
    on<PostLoadMoreEvent>(_onLoadMore);
  }

  static const int _pageSize = 5;

  final FetchMobilePostsUseCase _fetchMobilePostsUseCase;

  void fetchHomePreview() {
    add(const PostFetchHomePreviewEvent());
  }

  void fetchPromotions() {
    add(const PostFetchEvent(MobilePostCategory.promotion));
  }

  void fetchNews() {
    add(const PostFetchEvent(MobilePostCategory.news));
  }

  void loadMorePromotions() {
    add(const PostLoadMoreEvent(MobilePostCategory.promotion));
  }

  void loadMoreNews() {
    add(const PostLoadMoreEvent(MobilePostCategory.news));
  }

  FutureOr<void> _onFetchHomePreview(
    PostFetchHomePreviewEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(
      state.copyWith(
        promotionsResource: Resource.loading(
          data: state.promotionsResource.data,
        ),
        newsResource: Resource.loading(data: state.newsResource.data),
      ),
    );

    final promotionsFuture = _fetchPosts(MobilePostCategory.promotion, page: 1);
    final newsFuture = _fetchPosts(MobilePostCategory.news, page: 1);
    final promotionsResponse = await promotionsFuture;
    final newsResponse = await newsFuture;

    emit(
      state.copyWith(
        promotionsResource: promotionsResponse,
        listPromotions: promotionsResponse.state == Result.success
            ? promotionsResponse.data?.items ?? []
            : state.listPromotions,
        newsResource: newsResponse,
        listNews: newsResponse.state == Result.success
            ? newsResponse.data?.items ?? []
            : state.listNews,
      ),
    );
  }

  FutureOr<void> _onFetch(PostFetchEvent event, Emitter<PostState> emit) async {
    emit(_copyWithLoading(event.category));

    final response = await _fetchPosts(event.category, page: 1);
    emit(_copyWithResponse(event.category, response, replaceItems: true));
  }

  FutureOr<void> _onLoadMore(
    PostLoadMoreEvent event,
    Emitter<PostState> emit,
  ) async {
    final pageData = _pageData(event.category);
    if (pageData?.hasMore != true) return;

    emit(_copyWithLoading(event.category));
    final response = await _fetchPosts(
      event.category,
      page: (pageData?.page ?? 1) + 1,
    );
    emit(_copyWithResponse(event.category, response, replaceItems: false));
  }

  Future<Resource<PromotionsPageEntity>> _fetchPosts(
    MobilePostCategory category, {
    required int page,
  }) {
    return _fetchMobilePostsUseCase.call(
      category: category,
      page: page,
      perPage: _pageSize,
    );
  }

  PromotionsPageEntity? _pageData(MobilePostCategory category) {
    return switch (category) {
      MobilePostCategory.promotion => state.promotionsResource.data,
      MobilePostCategory.news => state.newsResource.data,
    };
  }

  PostState _copyWithLoading(MobilePostCategory category) {
    return switch (category) {
      MobilePostCategory.promotion => state.copyWith(
        promotionsResource: Resource.loading(
          data: state.promotionsResource.data,
        ),
      ),
      MobilePostCategory.news => state.copyWith(
        newsResource: Resource.loading(data: state.newsResource.data),
      ),
    };
  }

  PostState _copyWithResponse(
    MobilePostCategory category,
    Resource<PromotionsPageEntity> response, {
    required bool replaceItems,
  }) {
    final List<PromotionProgramEntity> currentItems = switch (category) {
      MobilePostCategory.promotion => state.listPromotions,
      MobilePostCategory.news => state.listNews,
    };
    final List<PromotionProgramEntity> nextItems =
        response.state == Result.success
        ? replaceItems
              ? response.data?.items ?? const <PromotionProgramEntity>[]
              : <PromotionProgramEntity>[
                  ...currentItems,
                  ...(response.data?.items ?? const <PromotionProgramEntity>[]),
                ]
        : currentItems;

    return switch (category) {
      MobilePostCategory.promotion => state.copyWith(
        promotionsResource: response,
        listPromotions: nextItems,
      ),
      MobilePostCategory.news => state.copyWith(
        newsResource: response,
        listNews: nextItems,
      ),
    };
  }
}
