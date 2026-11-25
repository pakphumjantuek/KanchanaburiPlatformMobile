String formatOrderDate(DateTime dateTime) {
  const months = [
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.',
  ];
  final thaiTime = dateTime.toUtc().add(const Duration(hours: 7));
  final monthName = months[thaiTime.month - 1];
  final yearThai = thaiTime.year + 543;
  final minute = thaiTime.minute.toString().padLeft(2, '0');
  return '${thaiTime.day} $monthName $yearThai - ${thaiTime.hour}:$minute น.';
}
