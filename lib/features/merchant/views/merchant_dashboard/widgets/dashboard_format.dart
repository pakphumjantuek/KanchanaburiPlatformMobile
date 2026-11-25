String formatCurrency(double amount) {
  final str = amount.toStringAsFixed(2);
  final parts = str.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
  return '฿$intPart';
}
