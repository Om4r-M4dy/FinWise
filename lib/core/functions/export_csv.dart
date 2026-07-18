import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';

/// Converts a list of [TransactionModel] into a CSV file and opens the native share sheet.
/// 
/// Headers: Date, Title, Category, Type, Amount
/// Returns true if export was initiated successfully, false otherwise.
Future<bool> exportTransactionsToCsv(
  List<TransactionModel> transactions, {
  String fileName = 'transactions_export.csv',
}) async {
  if (transactions.isEmpty) return false;

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  final StringBuffer csvBuffer = StringBuffer();

  // CSV Header
  csvBuffer.writeln('Date,Title,Category,Type,Amount');

  // CSV Rows
  for (final tx in transactions) {
    final String formattedDate = _escapeCsvField(formatter.format(tx.date));
    final String title = _escapeCsvField(tx.title);
    final String category = _escapeCsvField(
      tx.categoryName.isNotEmpty ? tx.categoryName : 'General',
    );
    final String type = _escapeCsvField(
      tx.type.isNotEmpty
          ? '${tx.type[0].toUpperCase()}${tx.type.substring(1).toLowerCase()}'
          : 'Expense',
    );
    final String amount = tx.amount.toStringAsFixed(2);

    csvBuffer.writeln('$formattedDate,$title,$category,$type,$amount');
  }

  try {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsString(csvBuffer.toString());

    final xFile = XFile(file.path, mimeType: 'text/csv');
    await Share.shareXFiles(
      [xFile],
      subject: 'FinWise Transactions Export',
    );

    return true;
  } catch (e) {
    return false;
  }
}

String _escapeCsvField(String field) {
  if (field.contains(',') || field.contains('"') || field.contains('\n')) {
    final escaped = field.replaceAll('"', '""');
    return '"$escaped"';
  }
  return field;
}
