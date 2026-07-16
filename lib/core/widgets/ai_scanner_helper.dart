import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/services/gemini_service.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AIScannerHelper {
  static void showAIScannerSheet(BuildContext context, {bool isAlreadyOnAddScreen = false}) {
    final aiNotesController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Resize sheet when keyboard opens
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lettersAndIcons.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      'AI Scanner',
                      style: TextStyles.bodyLarge.copyWith(fontSize: 18),
                    ),
                    const Gap(16),
                    TextFormField(
                      controller: aiNotesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightGreen,
                        hintText: "Add instruction or hint for the AI (optional)...",
                        hintStyle: TextStyles.bodySmall.copyWith(
                          color: AppColors.lettersAndIcons.withValues(alpha: 0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.lettersAndIcons,
                      ),
                    ),
                    const Gap(16),
                    ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.mainGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.mainGreen,
                        ),
                      ),
                      title: const Text(
                        'Camera',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Scan document / record using camera',
                        style: TextStyle(
                          color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        final userInstructions = aiNotesController.text;
                        Navigator.pop(sheetContext);
                        _scanImage(
                          context,
                          ImageSource.camera,
                          isAlreadyOnAddScreen: isAlreadyOnAddScreen,
                          userInstructions: userInstructions,
                        );
                      },
                    ),
                    ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.mainGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library_rounded,
                          color: AppColors.mainGreen,
                        ),
                      ),
                      title: const Text(
                        'Gallery',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Upload image from gallery',
                        style: TextStyle(
                          color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        final userInstructions = aiNotesController.text;
                        Navigator.pop(sheetContext);
                        _scanImage(
                          context,
                          ImageSource.gallery,
                          isAlreadyOnAddScreen: isAlreadyOnAddScreen,
                          userInstructions: userInstructions,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() => aiNotesController.dispose());
  }

  static Future<void> _scanImage(
    BuildContext context,
    ImageSource source, {
    required bool isAlreadyOnAddScreen,
    required String userInstructions,
  }) async {
    // Capture cubit before async gap to avoid reading context after disposal
    final TransactionCubit? cubit =
        isAlreadyOnAddScreen ? context.read<TransactionCubit>() : null;

    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null || !context.mounted) return;

      // Show loading dialog
      LoadingDialog.show(context);

      try {
        final result = await GeminiService.scanImage(
          pickedFile.path,
          userInstructions: userInstructions,
        );

        if (!context.mounted) return;
        LoadingDialog.hide(context);

        CustomSnackBar.showSuccess(context, 'Scanned successfully!');

        final title = result['title'];
        final categoryName = result['category'];
        final amount = (result['amount'] as num?)?.toDouble();
        final note = result['note'];
        final type = result['type'];

        if (isAlreadyOnAddScreen && cubit != null) {
          if (title != null) cubit.titleController.text = title;
          if (amount != null) {
            cubit.amountController.text = amount.toStringAsFixed(2);
          }
          if (note != null) cubit.noteController.text = note;
          if (type != null) {
            if (type.toLowerCase() == 'income') {
              cubit.setType(TransactionTypeEnum.income.value);
            } else {
              cubit.setType(TransactionTypeEnum.expense.value);
            }
          }
          if (categoryName != null) {
            final categoryId = getCategoryId(categoryName);
            cubit.setCategory(categoryId);
          }
        } else {
          // Prepopulate and push to AddTransaction screen
          pushTo(
            context,
            Routes.addTransaction,
            extra: {
              'title': title,
              'category': categoryName,
              'amount': amount,
              'note': note,
              'type': type,
            },
          );
        }
      } catch (e) {
        if (context.mounted) {
          LoadingDialog.hide(context);
          CustomSnackBar.showError(context, 'Failed to scan: $e');
        }
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(context, 'Could not pick image: $e');
      }
    }
  }
}
