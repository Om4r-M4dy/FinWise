import 'dart:io';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/services/gemini_service.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class AIScannerHelper {
  static void showAIScannerSheet(BuildContext context, {bool isAlreadyOnAddScreen = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Resize sheet when keyboard opens
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return _AIScannerSheetContent(
          parentContext: context,
          isAlreadyOnAddScreen: isAlreadyOnAddScreen,
        );
      },
    );
  }

  static Future<void> _scanImage(
    BuildContext context,
    String imagePath, {
    required bool isAlreadyOnAddScreen,
    required String userInstructions,
  }) async {
    // Capture cubit before async gap to avoid reading context after disposal
    final TransactionCubit? cubit =
        isAlreadyOnAddScreen ? context.read<TransactionCubit>() : null;

    // Show loading dialog
    LoadingDialog.show(context);

    try {
      final result = await GeminiService.scanImage(
        imagePath,
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
  }
}

class _AIScannerSheetContent extends StatefulWidget {
  final BuildContext parentContext;
  final bool isAlreadyOnAddScreen;

  const _AIScannerSheetContent({
    required this.parentContext,
    required this.isAlreadyOnAddScreen,
  });

  @override
  State<_AIScannerSheetContent> createState() => _AIScannerSheetContentState();
}

class _AIScannerSheetContentState extends State<_AIScannerSheetContent> {
  late final TextEditingController _aiNotesController;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _aiNotesController = TextEditingController();
  }

  @override
  void dispose() {
    _aiNotesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Could not pick image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  _selectedImage == null ? 'AI Scanner' : 'Confirm & Customize',
                  style: TextStyles.bodyLarge.copyWith(fontSize: 18),
                ),
                const Gap(16),
                if (_selectedImage == null) ...[
                  // Step 1: Select Source
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
                    onTap: () => _pickImage(ImageSource.camera),
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
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ] else ...[
                  // Step 2: Preview & Notes
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_selectedImage!.path),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _aiNotesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGreen,
                      hintText: "Add instruction or hint for the AI (optional)... e.g., 'Exclude sales tax', 'This was for coffee'",
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
                  MainButton(
                    text: 'Scan with AI',
                    size: ButtonSize.large,
                    onPress: () {
                      final imagePath = _selectedImage!.path;
                      final userInstructions = _aiNotesController.text;
                      Navigator.pop(context);
                      AIScannerHelper._scanImage(
                        widget.parentContext,
                        imagePath,
                        isAlreadyOnAddScreen: widget.isAlreadyOnAddScreen,
                        userInstructions: userInstructions,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
