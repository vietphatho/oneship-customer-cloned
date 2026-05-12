class AddShopStaffRequest {
  const AddShopStaffRequest({
    required this.userId,
    required this.permissions,
  });

  final String userId;
  final Map<String, Map<String, bool>> permissions;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "permissions": permissions,
    };
  }
}
