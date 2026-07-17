import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
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
      appBar: DefaultAppBar(title: "Change Pin"),
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
                  onPress: () {
                    // Handle change pin logic
                    replaceWith(context, Routes.loadingChangePinScreen);
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
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffDCEAE3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.lettersAndIcons,
          ),
        ),
      ),
    );
  }
}
