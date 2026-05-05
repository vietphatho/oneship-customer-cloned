abstract class CreateMultiOrdersEvent {
  const CreateMultiOrdersEvent();
}

class CreateMultiOrdersPickExcelFileEvent extends CreateMultiOrdersEvent {
  final String filePath;
  const CreateMultiOrdersPickExcelFileEvent({required this.filePath});
}

class CreateMultiOrdersCreateEvent extends CreateMultiOrdersEvent {
  const CreateMultiOrdersCreateEvent();
}
