abstract class CreateComplaintEvent {
  const CreateComplaintEvent();
}

class CreateComplaintStarted extends CreateComplaintEvent {
  const CreateComplaintStarted();
}

class CreateComplaintSubmitted extends CreateComplaintEvent {
  final String category;
  final String priority;
  final String subject;
  final String description;
  final String referenceType;
  final String referenceId;
  final String shopId;

  const CreateComplaintSubmitted({
    required this.category,
    required this.priority,
    required this.subject,
    required this.description,
    required this.referenceType,
    required this.referenceId,
    required this.shopId,
  });
}
