import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/features/profile/data/models/user_model.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_layout.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/persentation/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/persentation/widgets/signup_screen_parts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
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

  // ── Inline error messages ───────────────────────────────────────────
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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

  // ── Validate Fields ─────────────────────────────────────────────────
  bool _validateFields() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool isValid = true;

    // Name validation
    if (name.isEmpty) {
      _nameError = 'Please enter your name';
      isValid = false;
    } else if (name.length < 2) {
      _nameError = 'Name must be at least 2 characters';
      isValid = false;
    } else {
      _nameError = null;
    }

    // Email validation
    if (email.isEmpty) {
      _emailError = 'Please enter your email';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
      isValid = false;
    } else {
      _emailError = null;
    }

    // Password validation
    if (password.isEmpty) {
      _passwordError = 'Please enter a password';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      _passwordError = null;
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Please confirm your password';
      isValid = false;
    } else if (password != confirmPassword) {
      _confirmPasswordError = 'Passwords do not match';
      isValid = false;
    } else {
      _confirmPasswordError = null;
    }

    setState(() {});
    return isValid;
  }

  // ── Sign Up Logic ────────────────────────────────────────────────────
  Future<void> _signUp() async {
    if (!_validateFields()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

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
        dob: _selectedDob?.millisecondsSinceEpoch.toDouble() ?? 0.0,
        profilePicture: userCredential.user!.photoURL ?? '',
        totalBalance: 0.0,
        totalExpense: 0.0,
        totalIncome: 0.0,
        monthlyBudgetLimit: 0.0,
        settings: {},
      );

      await FirestoreProvider.addUser(userModel);
      // ── Save name and login state using UserPrefs ────────────────
      await UserPrefs.setName(name);
      await UserPrefs.setIsLoggedIn(true);

      if (mounted) {
        context.read<UserCubit>().setUser(userModel);
        replaceWith(context, Routes.bottomNavBar);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          if (e.code == 'weak-password') {
            _passwordError = 'The password provided is too weak';
          } else if (e.code == 'email-already-in-use') {
            _emailError = 'This email is already registered';
          } else if (e.code == 'invalid-email') {
            _emailError = 'The email address is badly formatted';
          } else {
            _emailError = 'An error occurred. Please try again';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailError = 'An unexpected error occurred';
        });
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

            // Full Name
            LabeledField(
              label: "Full name",
              field: AuthTextField(
                hintText: "Your Name",
                controller: _nameController,
                errorText: _nameError,
              ),
            ),

            // Email
            LabeledField(
              label: "Email",
              field: AuthTextField(
                hintText: "example@example.com",
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            // Mobile Number
            LabeledField(label: "Mobile Number", field: _buildPhoneField()),

            // Date of Birth
            LabeledField(label: "Date of Birth", field: _buildDobField()),

            // Password
            LabeledField(
              label: "Password",
              field: AuthTextField(
                hintText: "Password",
                isPassword: true,
                controller: _passwordController,
                errorText: _passwordError,
              ),
            ),

            // Confirm Password
            LabeledField(
              label: "Confirm Password",
              field: AuthTextField(
                hintText: "Confirm Password",
                isPassword: true,
                controller: _confirmPasswordController,
                errorText: _confirmPasswordError,
              ),
            ),

            const Gap(28),
            const TermsNotice(),

            // Sign Up Button
            CustomAuthButton(
              text: "Sign Up",
              onPressed: _signUp,
              isLoading: _isLoading,
            ),

            const Gap(28),
            const Center(child: Text("or sign up with")),
            const Gap(19),
            const SocialButtonsRow(),
            const Gap(19),
            const AlreadyAccountLink(),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  /// Phone field with integrated country code picker
  Widget _buildPhoneField() {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: '10 123 4567',
        hintStyle: TextStyle(
          color: AppColors.lettersAndIcons.withValues(alpha: 0.4),
          fontFamily: AppFonts.poppins,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lettersAndIcons.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lettersAndIcons.withValues(alpha: 0.2),
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
      initialCountryCode: 'EG',
      onChanged: (phone) {
        _completePhoneNumber = phone.completeNumber;
      },
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      showDropdownIcon: true,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
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
              color: AppColors.lettersAndIcons.withValues(alpha: 0.4),
              fontFamily: AppFonts.poppins,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lettersAndIcons.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lettersAndIcons.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.mainGreen,
                width: 1.5,
              ),
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
