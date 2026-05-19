abstract class ComplaintEvent {
  const ComplaintEvent();
}

class ComplaintStarted extends ComplaintEvent {
  final String category;
  final String? shopId;

  const ComplaintStarted({required this.category, this.shopId});
}

class ComplaintDeleted extends ComplaintEvent {
  final String id;

  const ComplaintDeleted({required this.id});
}
