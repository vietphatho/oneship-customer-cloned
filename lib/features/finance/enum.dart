enum FinanceRequestSource {  page, filterDialog }

enum FinanceFilter { oneDay, sevenDay, thirtyDay, selectDate }

extension FinanceFilterX on FinanceFilter {
  static const _mapName = {
    FinanceFilter.oneDay: 'one_day',
    FinanceFilter.sevenDay: 'seven_day',
    FinanceFilter.thirtyDay: 'thirty_day',
    FinanceFilter.selectDate: 'select_date',
  };

  String get name => _mapName[this]!;

  DateTime? getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case FinanceFilter.oneDay:
        return DateTime(now.year, now.month, now.day - 1);
      case FinanceFilter.sevenDay:
        return DateTime(now.year, now.month, now.day - 7);
      case FinanceFilter.thirtyDay:
        return DateTime(now.year, now.month, now.day - 30);
      case FinanceFilter.selectDate:
        return null;
    }
  }
}