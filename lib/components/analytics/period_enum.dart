enum PeriodEnum { week, month, year }

extension PeriodLabel on PeriodEnum {
  String get periodLabel {
    switch (this) {
      case PeriodEnum.week:
        return 'This Week';
      case PeriodEnum.month:
        return 'This Month';
      case PeriodEnum.year:
        return 'This Year';
    }
  }

  String get display => periodLabel.toUpperCase();
}
