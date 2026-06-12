import 'package:flutter/cupertino.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_empty_data.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PrimaryRefreshabelListView extends StatelessWidget {
  const PrimaryRefreshabelListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.itemCount,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.onRefresh,
    this.onLoading,
    this.separatorBuilder,
    this.padding = AppDimensions.smallPaddingAll,
    this.footerBottomSpacing = 0.0,
    this.noMoreText,
  });

  final RefreshController controller;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double footerBottomSpacing;

  final bool enablePullDown;
  final bool enablePullUp;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final String? noMoreText;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: WaterDropHeader(
        waterDropColor: AppColors.primary,
        refresh: const SizedBox(
          width: AppDimensions.mediumIconSize,
          height: AppDimensions.mediumIconSize,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: AppColors.primary,
            strokeCap: StrokeCap.round,
          ),
        ),
        complete: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: AppColors.green,
        ),
        failed: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_rounded,
              color: AppColors.expenseRed,
              size: AppDimensions.smallIconSize,
            ),
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            PrimaryText(
              "error".tr(),
              style: AppTextStyles.bodySmall,
              color: AppColors.expenseRed,
            ),
          ],
        ),
      ),
      footer: CustomFooter(
        height: 72 + footerBottomSpacing,
        builder: (context, mode) {
          final currentMode = mode ?? LoadStatus.loading;
          return Container(
            padding: EdgeInsets.only(bottom: footerBottomSpacing),
            child: AnimatedSwitcher(
              duration: Durations.short4,
              reverseDuration: Durations.long1,
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child: _CustomFooter(key: ValueKey(currentMode), mode: currentMode, noMoreText: noMoreText),
            ),
          );
        },
      ),
      child:
          itemCount == 0
              ? const SizedBox.expand(child: Center(child: PrimaryEmptyData()))
              : ListView.separated(
                padding: padding,
                itemBuilder: itemBuilder,
                itemCount: itemCount,
                separatorBuilder:
                    separatorBuilder ?? (_, __) => const SizedBox(),
              ),
    );
  }
}

class _CustomFooter extends StatelessWidget {
  const _CustomFooter({super.key, required this.mode, this.noMoreText});

  final LoadStatus mode;
  final String? noMoreText;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case LoadStatus.loading:
        return const _FooterLoading();
      case LoadStatus.failed:
        return const _FooterFailed();
      case LoadStatus.noMore:
        return _FooterNoMore(text: noMoreText);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _FooterLoading extends StatelessWidget {
  const _FooterLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: AppDimensions.mediumIconSize,
        height: AppDimensions.mediumIconSize,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: AppColors.primary,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}

class _FooterFailed extends StatelessWidget {
  const _FooterFailed();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.largeIconSize,
          child: Image.asset(
            "assets/images/waypoint_fail.png",
            color: AppColors.neutral7,
          ),
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryText(
          "load_failed_pull_up".tr(),
          style: AppTextStyles.bodySmall,
          color: AppColors.expenseRed,
        ),
      ],
    );
  }
}

class _FooterNoMore extends StatelessWidget {
  const _FooterNoMore({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.largeIconSize,
          child: Image.asset(
            "assets/images/empty_list.png",
            color: AppColors.neutral7,
          ),
        ),
        AppSpacing.vertical(AppDimensions.xSmallSpacing),
        PrimaryText(
          text ?? "no_more_data".tr(),
          style: AppTextStyles.bodySmall,
          color: AppColors.neutral6,
        ),
      ],
    );
  }
}
