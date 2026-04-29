import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Updated Helper: 3 Dots (Matches Signup Position/Logic) ---
  Widget _buildHeaderDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Left aligned like Signup
      children: List.generate(
          3,
          (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  // First two are white, last one is low opacity
                  color: i < 2 ? Colors.white : Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              )),
    );
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

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter your email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(email: email, password: password);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
      body: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align header content left
                      children: [
                        const SizedBox(height: 16),

                        // ── Three Dots (Positioned exactly like Signup) ──
                        _buildHeaderDots(),

                        const SizedBox(height: 22),

                        // ── Logo (Centered relative to its container) ──
                        Center(
                          child: Image.asset(
                            'assets/images/my_logo.png',
                            height: 230,
                            width: 230,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Branding Text ──
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'INTELLIGENT',
                                style: GoogleFonts.poppins(
                                  color: AppColors.gold,
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'ADMISSIONS ASSISTANT',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Input Fields ──
                        AppTextField(
                          hintText: 'Email',
                          prefixIcon: Icons.person_outline_rounded,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom Action Card ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 36),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isLoading ? null : _onForgotPassword,
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : AppButton(label: 'Login', onPressed: _onLogin),
                    const SizedBox(height: 14),
                    Text(
                      'or',
                      style: GoogleFonts.poppins(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      label: 'Create an account',
                      onPressed: _isLoading ? () {} : _onCreateAccount,
                      backgroundColor: AppColors.primaryPale,
                      textColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation helpers
  void _onCreateAccount() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const SignupScreen()));
  void _onForgotPassword() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
}
