import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:oneship_customer/core/base/components/primary_refreshable_list_view.dart';
import 'package:oneship_customer/core/base/constants/enum.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/promotion_program_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/post_state.dart';
import 'package:oneship_customer/features/shop_home/presentation/widgets/promotion_program_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShopHomePostListPage extends StatefulWidget {
  const ShopHomePostListPage({
    super.key,
    required this.title,
    required this.category,
  });

  final String title;
  final MobilePostCategory category;

  @override
  State<ShopHomePostListPage> createState() => _ShopHomePostListPageState();
}

class _ShopHomePostListPageState extends State<ShopHomePostListPage> {
  final RefreshController _refreshController = RefreshController();
  final PostBloc _postBloc = getIt.get();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    if (_items(_postBloc.state).isEmpty) {
      _fetch();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PrimaryAppBar(title: widget.title),
      body: BlocConsumer<PostBloc, PostState>(
        bloc: _postBloc,
        listenWhen: (previous, current) =>
            _resource(previous) != _resource(current),
        listener: _handleResourceChanged,
        buildWhen: (previous, current) =>
            _resource(previous) != _resource(current) ||
            _items(previous) != _items(current),
        builder: (context, state) {
          final posts = _items(state);
          final resource = _resource(state);
          final isLoading = resource.state == Result.loading && posts.isEmpty;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resource.state == Result.error && posts.isEmpty) {
            return PrimaryEmptyData(onRetry: _fetch);
          }

          if (posts.isEmpty) {
            return PrimaryEmptyData(onRetry: _fetch);
          }

          return PrimaryRefreshabelListView(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: _hasMore(state),
            onRefresh: _refresh,
            onLoading: _loadMore,
            padding: AppDimensions.smallPaddingAll.copyWith(
              bottom: AppDimensions.safeBottomSpacing,
            ),
            itemCount: posts.length,
            separatorBuilder: (context, index) =>
                AppSpacing.vertical(AppDimensions.smallSpacing),
            itemBuilder: (context, index) {
              return ShopHomeArticleCard(
                article: posts[index],
                showDate: true,
                layout: ShopHomeArticleCardLayout.horizontal,
              );
            },
          );
        },
      ),
    );
  }

  Resource<PromotionsPageEntity> _resource(PostState state) {
    return switch (widget.category) {
      MobilePostCategory.promotion => state.promotionsResource,
      MobilePostCategory.news => state.newsResource,
    };
  }

  List<PromotionProgramEntity> _items(PostState state) {
    return switch (widget.category) {
      MobilePostCategory.promotion => state.listPromotions,
      MobilePostCategory.news => state.listNews,
    };
  }

  bool _hasMore(PostState state) {
    return switch (widget.category) {
      MobilePostCategory.promotion => state.hasMorePromotions,
      MobilePostCategory.news => state.hasMoreNews,
    };
  }

  void _fetch() {
    switch (widget.category) {
      case MobilePostCategory.promotion:
        _postBloc.fetchPromotions();
        break;
      case MobilePostCategory.news:
        _postBloc.fetchNews();
        break;
    }
  }

  void _refresh() {
    _isLoadingMore = false;
    _fetch();
  }

  void _loadMore() {
    if (!_hasMore(_postBloc.state)) {
      _refreshController.loadNoData();
      return;
    }

    _isLoadingMore = true;
    switch (widget.category) {
      case MobilePostCategory.promotion:
        _postBloc.loadMorePromotions();
        break;
      case MobilePostCategory.news:
        _postBloc.loadMoreNews();
        break;
    }
  }

  void _handleResourceChanged(BuildContext context, PostState state) {
    switch (_resource(state).state) {
      case Result.success:
        if (_isLoadingMore) {
          _refreshController.loadComplete();
          if (!_hasMore(state)) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController
            ..refreshCompleted()
            ..resetNoData();
        }
        _isLoadingMore = false;
        break;
      case Result.error:
        if (_isLoadingMore) {
          _refreshController.loadFailed();
        } else {
          _refreshController.refreshFailed();
        }
        _isLoadingMore = false;
        break;
      case Result.loading:
        break;
    }
  }
}
