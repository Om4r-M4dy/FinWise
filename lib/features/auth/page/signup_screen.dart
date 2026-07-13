import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/facebook_auth.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/models/user_model.dart';
import 'package:finwise/features/auth/widgets/auth_layout.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:finwise/core/functions/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final double space = 16;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _completePhoneNumber = '';
  DateTime? _selectedDob;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Date of Birth Picker ────────────────────────────────────────────
  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 10, now.month, now.day),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.mainGreen,
              onPrimary: Colors.white,
              surface: AppColors.background,
              onSurface: AppColors.lettersAndIcons,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('dd / MM / yyyy').format(picked);
      });
    }
  }

  // ── Sign Up Logic ────────────────────────────────────────────────────
  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
      }

      var userModel = UserModel(
        username: name,
        email: email,
        phone: _completePhoneNumber,
        uid: userCredential.user!.uid,
        profilePicture: userCredential.user!.photoURL ?? '', totalBalance: null, totalExpense: null, monthlyBudgetLimit: null, settings: {},
      );

      FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid).set(userModel.toMap());

      if (mounted) {
        replaceWith(context, Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is badly formatted.';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: "Create Account",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(27),

            // ── Full Name ──────────────────────────────────────────────
            _label("Full name"),
            const Gap(8),
            AuthTextField(
              hintText: "Your Name",
              controller: _nameController,
            ),
            Gap(space),

            // ── Email ──────────────────────────────────────────────────
            _label("Email"),
            const Gap(8),
            AuthTextField(
              hintText: "example@example.com",
              controller: _emailController,
            ),
            Gap(space),

            // ── Mobile Number with Country Picker ─────────────────────
            _label("Mobile Number"),
            const Gap(8),
            _buildPhoneField(),
            Gap(space),

            // ── Date of Birth ──────────────────────────────────────────
            _label("Date of Birth"),
            const Gap(8),
            _buildDobField(),
            Gap(space),

            // ── Password ───────────────────────────────────────────────
            _label("Password"),
            const Gap(8),
            AuthTextField(
              hintText: "Password",
              isPassword: true,
              controller: _passwordController,
            ),
            Gap(space),

            // ── Confirm Password ───────────────────────────────────────
            _label("Confirm Password"),
            const Gap(8),
            AuthTextField(
              hintText: "Confirm Password",
              isPassword: true,
              controller: _confirmPasswordController,
            ),
            const Gap(28),

            const Center(child: Text("By continuing, you agree to ")),
            const Center(
              child: Text(
                "Terms of Use and Privacy Policy.",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Gap(13),

            // ── Sign Up Button ─────────────────────────────────────────
            CustomAuthButton(
              text: "Sign Up",
              onPressed: _signUp,
              isLoading: _isLoading,
            ),

            const Gap(28),
            const Center(child: Text("or sign up with")),
            const Gap(19),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(
                  icon: AppAssets.facebook,
                  onTap: () async {
                    final user =
                        await FacebookAuthService.signInWithFacebook(context);
                    if (user != null && context.mounted) {
                      replaceWith(context, Routes.bottomNavBar);
                    }
                  },
                ),
                const Gap(16),
                SocialButton(
                  icon: AppAssets.google,
                  onTap: () async {
                    final user = await GoogleAuth.signInWithGoogle(context);
                    if (user != null && context.mounted) {
                      replaceWith(context, Routes.bottomNavBar);
                    }
                  },
                ),
              ],
            ),
            const Gap(19),

            Center(
              child: GestureDetector(
                onTap: () => replaceWith(context, Routes.loginScreen),
                child: const Text("Already have an account? Log In"),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyles.caption1_14.copyWith(
        color: AppColors.lettersAndIcons,
        fontFamily: AppFonts.poppins,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Phone field with integrated country code picker
  Widget _buildPhoneField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: '10 123 4567',
        hintStyle: TextStyle(
          color: AppColors.lettersAndIcons.withOpacity(0.4),
          fontFamily: AppFonts.poppins,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lettersAndIcons.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lettersAndIcons.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mainGreen, width: 1.5),
        ),
      ),
      style: TextStyle(
        color: AppColors.lettersAndIcons,
        fontFamily: AppFonts.poppins,
        fontSize: 14,
      ),
      dropdownTextStyle: TextStyle(
        color: AppColors.lettersAndIcons,
        fontFamily: AppFonts.poppins,
        fontSize: 14,
      ),
      initialCountryCode: 'EG', // مصر افتراضياً
      onChanged: (phone) {
        _completePhoneNumber = phone.completeNumber;
      },
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      showDropdownIcon: true,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.lettersAndIcons.withOpacity(0.6),
      ),
    );
  }

  /// Date of birth field — opens date picker on tap
  Widget _buildDobField() {
    return GestureDetector(
      onTap: _pickDateOfBirth,
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dobController,
          style: TextStyle(
            color: AppColors.lettersAndIcons,
            fontFamily: AppFonts.poppins,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'DD / MM / YYYY',
            hintStyle: TextStyle(
              color: AppColors.lettersAndIcons.withOpacity(0.4),
              fontFamily: AppFonts.poppins,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lettersAndIcons.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lettersAndIcons.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.mainGreen, width: 1.5),
            ),
            suffixIcon: Icon(
              Icons.calendar_today_rounded,
              color: AppColors.mainGreen,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
