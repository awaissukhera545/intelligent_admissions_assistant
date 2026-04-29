import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading  = false;
  bool _emailSent  = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _onResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter your email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.sendPasswordReset(email: email);
      setState(() => _emailSent = true);
      _showSnackBar(
        'Reset link sent! Check your inbox.',
        isError: false,
      );
    } on FirebaseAuthException catch (e) {
      _showSnackBar(AuthService.friendlyError(e));
    } catch (_) {
      _showSnackBar('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (_) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: const BoxDecoration(
                          color: AppColors.textGrey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.close, color: AppColors.textGrey, size: 24),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Lock + key icon ───────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 82,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primaryLight, width: 2),
                  ),
                  child: Icon(
                    _emailSent
                        ? Icons.mark_email_read_outlined
                        : Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 46,
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: -10,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.vpn_key_rounded,
                      color: Color(0xFFF59E0B),
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ── Heading ───────────────────────────────────────────
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _emailSent ? 'Check Your\n' : 'Forgot\n',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: _emailSent ? 'Email' : 'Password?',
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryLight,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _emailSent
                  ? 'A reset link has been sent to\n${_emailController.text.trim()}'
                  : "No worries, we'll send you\nreset instructions",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.textGrey,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 32),

            // ── Purple form section ───────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: 'Enter your Email',
                      prefixIcon: Icons.mail_outline_rounded,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          )
                        : AppButton(
                            label: _emailSent ? 'Resend Email' : 'Reset Password',
                            onPressed: _onResetPassword,
                            backgroundColor: const Color(0xFFD8B4FE),
                            textColor: AppColors.primary,
                          ),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Back to Login',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
