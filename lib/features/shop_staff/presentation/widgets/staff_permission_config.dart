import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffPermissionGroup {
  const StaffPermissionGroup({
    required this.key,
    required this.labelKey,
    required this.icon,
    this.initiallyExpanded = false,
  });

  final String key;
  final String labelKey;
  final IconData icon;
  final bool initiallyExpanded;
}

class StaffPermissionAction {
  const StaffPermissionAction({required this.key, required this.labelKey});

  final String key;
  final String labelKey;
}

const staffPermissionGroups = [
  StaffPermissionGroup(
    key: "orders",
    labelKey: "shop_management.staff_permission_order",
    icon: CupertinoIcons.doc_text,
  ),
  StaffPermissionGroup(
    key: "staff",
    labelKey: "shop_management.staff_permission_staff",
    icon: CupertinoIcons.person_2,
  ),
  StaffPermissionGroup(
    key: "shops",
    labelKey: "shop_management.staff_permission_shop",
    icon: CupertinoIcons.cube_box,
  ),
  StaffPermissionGroup(
    key: "financial",
    labelKey: "shop_management.staff_permission_finance",
    icon: CupertinoIcons.money_dollar,
  ),
  StaffPermissionGroup(
    key: "settings",
    labelKey: "shop_management.staff_permission_utility",
    icon: CupertinoIcons.xmark,
  ),
];

const staffPermissionActions = [
  StaffPermissionAction(
    key: "view",
    labelKey: "shop_management.permission_view",
  ),
  StaffPermissionAction(
    key: "create",
    labelKey: "shop_management.permission_create",
  ),
  StaffPermissionAction(
    key: "update",
    labelKey: "shop_management.permission_update",
  ),
  StaffPermissionAction(
    key: "delete",
    labelKey: "shop_management.permission_delete",
  ),
];
