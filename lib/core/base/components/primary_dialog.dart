import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/liquid_glass_view.dart';

class PrimaryDialog {
  static const _headerIconSize = 64.0;
  static bool _isShowLoading = false;
  static bool get isShowLoading => _isShowLoading;

  static Future<dynamic> showAlertDialog(
    BuildContext context, {
    String title = "notification",
    String? message,
    Function()? onClosed,
  }) async {
    // var colorScheme = AppTheme.getColorScheme(context);
    // var isDarkMode = AppTheme.isDarkMode(context);

    return await showGeneralDialog(
      barrierLabel: "CustomDialog",
      barrierDismissible: true,
      context: context,
      pageBuilder: (_, aniamtion, __) {
        return _CustomDialogView(
          headerIcon: Container(
            width: _headerIconSize,
            height: _headerIconSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green100,
            ),
            child: const Icon(
              Icons.notifications,
              size: AppDimensions.mediumIconSize,
              color: AppColors.neutral7,
            ),
          ),
          body: Column(
            children: [
              PrimaryText(
                title.tr(),
                style: AppTextStyles.titleLarge,
                // color: colorScheme.onSurfaceVariant,
              ),
              if (message != null) ...[
                AppSpacing.vertical(AppDimensions.mediumSpacing),
                PrimaryText(
                  message.tr(),
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                  // color: colorScheme.onSurface,
                ),
              ],
            ],
          ),
          bottomActions: PrimaryButton.primary(
            label: "close".tr(),
            onPressed: () {
              Navigator.pop(context, true);
              onClosed?.call();
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<dynamic> showDefaultDialog(
    BuildContext context, {
    Widget child = const SizedBox.shrink(),
  }) async {
    return await showGeneralDialog(
      barrierLabel: "CustomDialog",
      barrierDismissible: true,
      context: context,
      pageBuilder: (BuildContext context, aniamtion, _) => child,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<dynamic> showSuccessDialog(
    BuildContext context, {
    String title = "success",
    String? message,
    String? closeText,
    void Function()? onClosed,
  }) {
    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder:
          (_, n, m) => _CustomDialogView(
            headerIcon: Container(
              width: _headerIconSize,
              height: _headerIconSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green100,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: AppDimensions.mediumIconSize,
              ),
            ),
            body: Column(
              children: [
                PrimaryText(
                  title.tr(),
                  style: AppTextStyles.titleLarge,
                  // color: colorScheme.onSurfaceVariant,
                ),
                if (message != null) ...[
                  AppSpacing.vertical(AppDimensions.mediumSpacing),
                  PrimaryText(
                    message.tr(),
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                    // color: colorScheme.onSurface,
                  ),
                ],
              ],
            ),
            bottomActions: PrimaryButton.primary(
              label: closeText?.tr() ?? "close".tr(),
              onPressed: () {
                Navigator.pop(context, true);
                onClosed?.call();
              },
            ),
          ),
    );
  }

  static Future<dynamic> showErrorDialog(
    BuildContext context, {
    String title = "error",
    String? message = "error",
    void Function()? onClosed,
    String? buttonText,
  }) {
    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder:
          (_, n, m) => _CustomDialogView(
            headerIcon: Container(
              width: _headerIconSize,
              height: _headerIconSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.expenseRed,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: AppDimensions.mediumIconSize,
                color: Colors.white,
              ),
            ),
            body: Column(
              children: [
                PrimaryText(
                  title.tr(),
                  style: AppTextStyles.titleLarge,
                  // color: colorScheme.onSurfaceVariant,
                ),
                AppSpacing.vertical(AppDimensions.smallSpacing),
                PrimaryText(
                  message!.tr(),
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                  // color: colorScheme.onSurface,
                ),
              ],
            ),
            bottomActions: PrimaryButton.primary(
              label: buttonText ?? "close".tr(),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
                onClosed?.call();
              },
            ),
          ),
    );
  }

  static Future<dynamic> showQuestionDialog(
    BuildContext context, {
    String title = "confirm",
    String? message,
    void Function()? onPositiveTapped,
    void Function()? onNegativeTapped,
    String positiveButtonText = "yes",
    String negativeButtonText = "cancel",
  }) {
    return showGeneralDialog<dynamic>(
      context: context,
      pageBuilder:
          (_, n, m) => _CustomDialogView(
            headerIcon: Container(
              width: _headerIconSize,
              height: _headerIconSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green100,
              ),
              child: const Icon(
                Icons.question_mark_rounded,
                size: AppDimensions.mediumIconSize,
              ),
            ),
            body: Column(
              children: [
                PrimaryText(
                  title.tr(),
                  style: AppTextStyles.titleLarge,
                  // color: colorScheme.onSurfaceVariant,
                ),
                if (message != null) ...[
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                  PrimaryText(
                    message,
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                    // color: colorScheme.onSurface,
                  ),
                  AppSpacing.vertical(AppDimensions.smallSpacing),
                ],
              ],
            ),
            bottomActions: Row(
              children: [
                Expanded(
                  child: PrimaryButton.secondary(
                    label: negativeButtonText.tr(),
                    onPressed: () {
                      Navigator.pop(context, true);
                      onNegativeTapped?.call();
                    },
                  ),
                ),
                AppSpacing.horizontal(AppDimensions.smallSpacing),
                Expanded(
                  child: PrimaryButton.primary(
                    label: positiveButtonText.tr(),
                    onPressed: () {
                      Navigator.pop(context, true);
                      onPositiveTapped?.call();
                    },
                  ),
                ),
              ],
            ),
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    Widget? header,
    required Widget child,
    Widget? actionButtons,
    EdgeInsetsGeometry? padding,
  }) {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder:
          (_, n, m) => StatefulBuilder(
            builder: (context, _) {
              final viewInsets = MediaQuery.of(context).viewInsets;
              return AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.only(bottom: viewInsets.bottom),
                curve: Curves.easeOut,
                child: _CustomDialogView(
                  headerIcon: header,
                  body: child,
                  bottomActions: actionButtons,
                  padding: padding,
                ),
              );
            },
          ),
    );
  }

  static void showLoadingDialog(
    BuildContext context, {
    String title = "handling",
  }) {
    if (_isShowLoading) return;

    _isShowLoading = true;
    try {
      showGeneralDialog<dynamic>(
        context: context,
        pageBuilder:
            (_, n, m) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xxxLargeSpacing,
              ),
              child: _CustomDialogView(
                headerIcon: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 6,
                  ),
                ),
                body: Column(
                  children: [
                    PrimaryText(
                      title.tr(),
                      style: AppTextStyles.bodyLarge,
                      // color: colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
      ).then((_) => _isShowLoading = false);
    } catch (e) {
      _isShowLoading = false;
    }
  }

  static void hideLoadingDialog(BuildContext context) {
    if (!_isShowLoading) return;
    Navigator.pop(context);
    _isShowLoading = false;
  }
}

class _CustomDialogView extends StatelessWidget {
  const _CustomDialogView({
    this.headerIcon,
    this.body,
    this.bottomActions,
    this.padding,
  });

  final Widget? headerIcon;
  final Widget? body;
  final Widget? bottomActions;
  final EdgeInsetsGeometry? padding;

  static final borderRadius = AppDimensions.largeBorderRadius;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Padding(
          padding: AppDimensions.largePaddingAll,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: LiquidGlassView(
              borderRadius: borderRadius,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: padding ?? AppDimensions.largePaddingAll,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (headerIcon != null) ...[
                        headerIcon ?? const SizedBox(),
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                      ],
                      if (body != null) body!,
                      if (bottomActions != null) ...[
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                        bottomActions!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
