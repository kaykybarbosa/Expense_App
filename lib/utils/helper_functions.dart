

int calculateMonthCount(startYear, startMonth, currentYear, currentMonth) =>
    (currentYear - startYear) * 12 + currentMonth - startMonth + 1;

String getMonthByNumber(value) => switch (value.toInt() % 12) {
  0 => 'Jan',
  1 => 'Fev',
  2 => 'Mar',
  3 => 'Abr',
  4 => 'Mai',
  5 => 'Jun',
  6 => 'Jul',
  7 => 'Ago',
  8 => 'Set',
  9 => 'Out',
  10 => 'Nov',
  11 => 'Dez',
  _ => '',
};

String getCurrentMonth() {
  int month = DateTime.now().month;

  List months = [
    "JAN",
    "FEV",
    "MAR",
    "ABR",
    "MAI",
    "JUN",
    "JUL",
    "AGO",
    "SET",
    "OUT",
    "NOV",
    "DEZ",
  ];

  return months[month - 1];
}
