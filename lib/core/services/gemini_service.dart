import 'dart:convert';
import 'dart:io';
import 'package:finwise/core/constants/api_keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static Future<Map<String, dynamic>> scanImage(
    String imagePath, {
    String? userInstructions,
  }) async {
    // 1. Get the API key
    final apiKey = ApiKeys.geminiApiKey;

    if (apiKey.isEmpty) {
      throw Exception(
        'Gemini API key is not configured.\n'
        'Please set your API key in lib/core/constants/api_keys.dart or '
        'run the app with --dart-define=GEMINI_API_KEY=your_key.',
      );
    }

    // 2. Initialize the Gemini model (using gemini-3.1-flash-lite which is available on this API key)
    final model = GenerativeModel(
      model: 'gemini-3.1-flash-lite',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    // 3. Read image file as bytes
    final imageBytes = await File(imagePath).readAsBytes();

    // 4. Predefined categories in FinWise
    final categoriesList = [
      'Food',
      'Medicine',
      'Travel',
      'Transport',
      'Gifts',
      'Rent',
      'Leisure',
      'Groceries',
      'Other',
    ];

    // 5. Build prompt
    final prompt =
        '''
You are an AI financial scanner. Please analyze this image (which could be a receipt, invoice, bill, bank statement, or transaction record) and extract the following details:
1. title: An informative title for the transaction, combining the merchant name/source with a very brief description of what it was for (e.g. 'Walmart - Groceries', 'Starbucks - Coffee', 'Shell Gas - Fuel Refill', 'Employer Name - Paycheck'). Keep it concise but highly descriptive.
2. category: Choose the most appropriate category from this exact list: $categoriesList. You must choose one of these exact strings.
3. amount: The total amount paid or received as a double.
4. note: What was bought or the purpose of the transaction (e.g. "Bought coffee and donuts", "Electric bill payment", etc.).
5. type: Determine if this transaction is an 'expense' (spending money, e.g. shopping, dining, bill payments) or 'income' (receiving money, e.g. paycheck, deposits, refunds). Choose either 'expense' or 'income'.

Your response must be a valid JSON object matching this schema:
{
  "title": String,
  "category": String,
  "amount": Double,
  "note": String,
  "type": String
}
''';

    String finalPrompt = prompt;
    if (userInstructions != null && userInstructions.trim().isNotEmpty) {
      finalPrompt +=
          '\n\nAdditional User Instructions/Context:\n'
          '${userInstructions.trim()}\n'
          'Please respect and follow the above user instructions when analyzing and extracting the details.';
    }

    final content = [
      Content.multi([
        TextPart(finalPrompt),
        DataPart(_getMimeType(imagePath), imageBytes),
      ]),
    ];

    // 6. Generate content
    final response = await model.generateContent(content);
    final responseText = response.text;
    if (responseText == null || responseText.isEmpty) {
      throw Exception('Failed to get any response from the Gemini API.');
    }

    // 7. Clean potential markdown block formatting from JSON response
    String cleanedResponse = responseText.trim();
    if (cleanedResponse.startsWith('```')) {
      final lines = cleanedResponse.split('\n');
      if (lines.first.startsWith('```')) {
        lines.removeAt(0);
      }
      if (lines.isNotEmpty && lines.last.startsWith('```')) {
        lines.removeLast();
      }
      cleanedResponse = lines.join('\n').trim();
    }

    // 8. Decode JSON
    try {
      final parsed = json.decode(cleanedResponse) as Map<String, dynamic>;
      return {
        'title': parsed['title'] ?? 'Receipt Transaction',
        'category': parsed['category'] ?? 'Other',
        'amount': (parsed['amount'] as num?)?.toDouble() ?? 0.0,
        'note': parsed['note'] ?? '',
        'type': parsed['type'] ?? 'expense',
      };
    } catch (e) {
      throw Exception(
        'Failed to parse Gemini response: $cleanedResponse\nError: $e',
      );
    }
  }

  static String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' || 'heif' => 'image/heic',
      'bmp' => 'image/bmp',
      _ => 'image/jpeg',
    };
  }
}
