import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChangepinScreen extends StatefulWidget {
  const ChangepinScreen({super.key});

  @override
  State<ChangepinScreen> createState() => _ChangepinScreenState();
}

class _ChangepinScreenState extends State<ChangepinScreen> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _obscureCurrentPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: "Change Pin"),
      body: MyBodyView(
        bottomSection: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),

              /// Current Pin
              Text("Current Pin", style: TextStyles.bodyMedium),
              const Gap(8),
              _buildPinField(
                controller: _currentPinController,
                obscure: _obscureCurrentPin,
                onToggle: () {
                  setState(() => _obscureCurrentPin = !_obscureCurrentPin);
                },
              ),

              const Gap(24),

              /// New Pin
              Text("New Pin", style: TextStyles.bodyMedium),
              const Gap(8),
              _buildPinField(
                controller: _newPinController,
                obscure: _obscureNewPin,
                onToggle: () {
                  setState(() => _obscureNewPin = !_obscureNewPin);
                },
              ),

              const Gap(24),

              /// Confirm Pin
              Text("Confirm Pin", style: TextStyles.bodyMedium),
              const Gap(8),
              _buildPinField(
                controller: _confirmPinController,
                obscure: _obscureConfirmPin,
                onToggle: () {
                  setState(() => _obscureConfirmPin = !_obscureConfirmPin);
                },
              ),

              const Gap(40),

              /// Change Pin Button
              Center(
                child: MainButton(
                  text: "Change Pin",
                  onPress: () async {
                    final currentPin = _currentPinController.text;
                    final newPin = _newPinController.text;
                    final confirmPin = _confirmPinController.text;

                    if (currentPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All fields are required.")),
                      );
                      return;
                    }

                    if (currentPin != UserPrefs.getPin()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Current PIN is incorrect.")),
                      );
                      return;
                    }

                    if (newPin.length != 6 || int.tryParse(newPin) == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("New PIN must be a 6-digit number.")),
                      );
                      return;
                    }

                    if (newPin != confirmPin) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("New PIN and Confirm PIN do not match.")),
                      );
                      return;
                    }

                    // Save new PIN
                    await UserPrefs.setPin(newPin);

                    if (context.mounted) {
                      replaceWith(context, Routes.loadingChangePinScreen);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: TextInputType.number,
      maxLength: 6,
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.lettersAndIcons,
      ),
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: isDark ? AppColors.darkGreen : const Color(0xffDCEAE3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.lettersAndIcons.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
