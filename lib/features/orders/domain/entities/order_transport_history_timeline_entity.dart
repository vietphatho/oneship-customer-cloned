class OrderTransportHistoryTimelineEntity {
  const OrderTransportHistoryTimelineEntity({
    required this.title,
    required this.description,
    required this.time,
    this.images = const [],
    this.showCompletedTag = false,
  });

  final String title;
  final String description;
  final DateTime time;
  final List<String> images;
  final bool showCompletedTag;
}
