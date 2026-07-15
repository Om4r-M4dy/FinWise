import 'package:finwise/core/constants/categories.dart';

String getCategoryId(String label) {
  return categories.firstWhere(
    (c) => c['label'] == label,
    orElse: () => {'key': '8'},
  )['key']!;
}
