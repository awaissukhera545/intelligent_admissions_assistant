import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../utils/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../data/uaf_programs_data.dart';
import 'home_screen.dart';
import 'terms_privacy_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypeController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserProfileService _profileService = UserProfileService();

  String? _selectedDiscipline;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypeController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: isError ? Colors.red.shade700 : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _onSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final retype = _retypeController.text;
    // Strip dashes for pure-digit length check (13 digits)
    final cnic = _cnicController.text.trim();
    final cnicDigits = cnic.replaceAll('-', '');

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all required fields.');
      return;
    }
    if (password != retype) {
      _showSnackBar('Passwords do not match.');
      return;
    }
    if (cnic.isNotEmpty && cnicDigits.length < 13) {
      _showSnackBar('Please enter a valid 13-digit CNIC number.');
      return;
    }
    if (!_agreeToTerms) {
      _showSnackBar('Please agree to the Terms & Privacy.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Create Firebase Auth account and get the credential
      final credential = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );

      // Step 2: Use the returned UID directly — avoids race condition
      // where _auth.currentUser might not be set yet in UserProfileService
      final uid = credential.user?.uid;
      if (uid == null) {
        _showSnackBar('Account created but profile could not be saved. Please try again.');
        return;
      }

      // Step 3: Save extended profile to Firestore using the explicit UID
      await _profileService.createProfileForUid(
        uid: uid,
        name: name,
        email: email,
        cnic: cnic,
        intermediateDiscipline: _selectedDiscipline ?? '',
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackBar(AuthService.friendlyError(e));
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // ── Header Section ─────────────────────────────────────
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              bottom: 30,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDotDecorations(),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Let's\n",
                              style: GoogleFonts.poppins(
                                color: AppColors.gold,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: 'Create\nAccount',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close, color: Colors.white70, size: 28),
                ),
              ],
            ),
          ),

          // ── Form Section ───────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Column(
                  children: [
                    _buildTextField(
                        'Full Name', Icons.person_outline, _nameController),
                    const SizedBox(height: 18),
                    _buildTextField(
                        'Email Address', Icons.mail_outline, _emailController,
                        inputType: TextInputType.emailAddress),
                    const SizedBox(height: 18),
                    _buildTextField(
                        'Password', Icons.lock_outline, _passwordController,
                        isObscure: true),
                    const SizedBox(height: 18),
                    _buildTextField('Confirm Password', Icons.shield_outlined,
                        _retypeController,
                        isObscure: true),

                    const SizedBox(height: 18),

                    // ── CNIC Field ──────────────────────────────────
                    _buildCnicField(),

                    const SizedBox(height: 18),

                    // ── Intermediate Discipline Dropdown ────────────
                    _buildDisciplineDropdown(),

                    const SizedBox(height: 24),

                    // --- Terms & Privacy Row ---
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              setState(() => _agreeToTerms = !_agreeToTerms),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _agreeToTerms
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _agreeToTerms
                                    ? AppColors.primary
                                    : AppColors.textGrey.withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: _agreeToTerms
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Wrap(
                            children: [
                              Text(
                                "I agree to the ",
                                style: GoogleFonts.poppins(
                                    color: AppColors.textGrey, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const TermsPrivacyScreen())),
                                child: Text(
                                  "Terms & Privacy",
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.primary)
                        : AppButton(label: 'Sign Up', onPressed: _onSignUp),

                    const SizedBox(height: 24),

                    // --- Login Redirect ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(
                              color: AppColors.textGrey, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── CNIC field with format mask #####-#######-# ───────────────────────
  Widget _buildCnicField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: TextField(
        controller: _cnicController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
          _CnicFormatter(),
        ],
        style: GoogleFonts.poppins(color: AppColors.textDark, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'CNIC (e.g. 36302-1234567-8)',
          hintStyle: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 15),
          prefixIcon: Icon(Icons.credit_card_rounded,
              color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  // ── Discipline Dropdown ───────────────────────────────────────────────
  Widget _buildDisciplineDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedDiscipline,
                hint: Text(
                  'Intermediate Discipline',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 15),
                ),
                style: GoogleFonts.poppins(
                    color: AppColors.textDark, fontSize: 15),
                items: UAFProgramsData.intermediateDisciplines
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedDiscipline = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to keep UI code clean and fix colors
  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller,
      {bool isObscure = false, TextInputType inputType = TextInputType.text}) {
    return AppTextField(
      hintText: hint,
      prefixIcon: icon,
      controller: controller,
      obscureText: isObscure,
      keyboardType: inputType,
      // Explicitly passing colors to fix your placeholder issue
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      hintColor: AppColors.textGrey,
      iconColor: AppColors.primary,
      textColor: AppColors.textDark,
    );
  }

  Widget _buildDotDecorations() {
    return Row(
      children: List.generate(
          3,
          (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: i == 0 ? 1.0 : 0.4),
                  shape: BoxShape.circle,
                ),
              )),
    );
  }
}

// ── CNIC Format Mask #####-#######-# ────────────────────────────────────────

class _CnicFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 5 || i == 12) buffer.write('-');
      buffer.write(digitsOnly[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
