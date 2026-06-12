abstract class ComplaintEvent {
  const ComplaintEvent();
}

class ComplaintStarted extends ComplaintEvent {
  final String category;
  final String? shopId;
  final String? status;

  const ComplaintStarted({required this.category, this.shopId, this.status});
}

class ComplaintDeleted extends ComplaintEvent {
  final String id;

  const ComplaintDeleted({required this.id});
}

class ComplaintLoadMore extends ComplaintEvent {
  const ComplaintLoadMore();
}
