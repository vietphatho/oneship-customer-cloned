import 'package:flutter/material.dart';
import 'package:oneship_customer/core/themes/app_dimensions.dart';


class ScreenMain extends StatelessWidget {
  const ScreenMain({
    super.key,
    required this.child,
    this.onBackHandler,
    this.appBarTitle,
    this.childHeader,
    this.centerTitle = true,
    this.onPress,
    this.iconRight,
    this.isBorderBottm = false,
    this.resizeToAvoidBottomInset,
    this.floating,
    this.isBack = true,
    this.leading,
    this.padding = EdgeInsets.zero,
    this.safeBottom = true,
  });

  final Widget child;
  final String? appBarTitle;
  final bool centerTitle;
  final Function()? onPress;
  final Widget? childHeader;
  final Function()? onBackHandler;
  final Widget? iconRight;
  final bool isBorderBottm;
  final Widget? floating;
  final bool? resizeToAvoidBottomInset;
  final bool isBack;
  final Widget? leading;

  final EdgeInsetsGeometry padding;
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isBack,
      onPopInvokedWithResult: (didPop, result) {
        if (onBackHandler != null) {
          onBackHandler!();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: HeaderScreenMain(
            text: appBarTitle,
            childHeader: childHeader,
            onPress: onPress,
            centerTitle: centerTitle,
            iconRight: iconRight,
            isBorderBottm: isBorderBottm,
            isBack: isBack,
            leading: leading,
          ),
        ),
        floatingActionButton: floating,
        body: SafeArea(
          top: false,
          bottom: safeBottom,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class HeaderScreenMain extends StatelessWidget {
  const HeaderScreenMain({
    super.key,
    required this.text,
    this.childHeader,
    this.onPress,
    this.centerTitle = true,
    this.iconRight,
    this.borderColor,
    this.isBorderBottm = false,
    this.isBack = true,
    this.leading,
  });

  final String? text;
  final Widget? childHeader;
  final Function()? onPress;
  final bool centerTitle;
  final Widget? iconRight;
  final Color? borderColor;
  final bool isBorderBottm;
  final bool isBack;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isBack,
      title:
          text != null
              // ? CustomText(
              //   bold: true,
              //   text: text,
              //   fontWeight: FontWeight.w700,
              //   size: 16,
              //   maxLine: 1,
              //   overflow: TextOverflow.ellipsis,
              // )
              ? Text(text ?? "")
              : childHeader,
      leading:
          isBack
              ? IconButton(
                onPressed: onPress ?? () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: AppDimensions.mediumIconSize,
                ),
              )
              : leading ?? Container(),
      actions: [Container(child: iconRight ?? const SizedBox())],
      centerTitle: centerTitle,
      shape: Border(
        bottom: BorderSide(
          width: isBorderBottm ? 0.2 : 0,
          color:
              isBorderBottm
                  ? borderColor ?? Theme.of(context).dividerColor
                  : Colors.transparent,
        ),
      ),
    );
  }
}
