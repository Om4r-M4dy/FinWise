/// Formats a financial amount to a compact string (e.g., $150k or $1.2M)
/// if it exceeds $10,000, otherwise displays it with 2 decimal places.
String formatAmount(double value, {bool isExpense = false}) {
  final absValue = value.abs();
  String formatted;
  if (absValue >= 1000000) {
    final millions = absValue / 1000000;
    final valueStr = millions.toStringAsFixed(
      millions.truncateToDouble() == millions ? 0 : 1,
    );
    formatted = '\$${valueStr}M';
  } else if (absValue >= 10000) {
    final thousands = absValue / 1000;
    final valueStr = thousands.toStringAsFixed(
      thousands.truncateToDouble() == thousands ? 0 : 1,
    );
    formatted = '\$${valueStr}k';
  } else {
    formatted = '\$${absValue.toStringAsFixed(2)}';
  }
  return isExpense ? '- $formatted' : formatted;
}
