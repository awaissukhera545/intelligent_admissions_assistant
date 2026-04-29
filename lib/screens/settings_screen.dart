import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_profile_service.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final UserProfileService _profileService = UserProfileService();
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoggingOut = false;

  // Extended profile data
  String? _cnic;
  String? _discipline;
  String? _profilePhotoUrl;
  bool _profileLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      if (profile != null && mounted) {
        setState(() {
          _cnic = profile['cnic'] as String?;
          _discipline = profile['intermediateDiscipline'] as String?;
          _profilePhotoUrl = profile['profilePhotoUrl'] as String?;
          _profileLoaded = true;
        });
      } else {
        if (mounted) setState(() => _profileLoaded = true);
      }
    } catch (_) {
      if (mounted) setState(() => _profileLoaded = true);
    }
  }

  Future<void> _onLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: GoogleFonts.poppins(
            color: AppColors.textGrey,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              'Log Out',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoggingOut = true);
    try {
      await _authService.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (_) {
      if (mounted) setState(() => _isLoggingOut = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _onAvatarTap() {
    // Show a dialog explaining photo upload
    // In real app, use image_picker here
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Profile Photo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          'To upload a profile photo, the image_picker and firebase_storage packages need to be configured. '
          'Add image_picker to pubspec.yaml and use:\n\n'
          'final picker = ImagePicker();\n'
          'final image = await picker.pickImage(source: ImageSource.gallery);',
          style: GoogleFonts.poppins(
            color: AppColors.textGrey,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Purple Header ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                children: [
                  // Avatar circle — tap to upload photo
                  GestureDetector(
                    onTap: _onAvatarTap,
                    child: Stack(
                      children: [
                        _profilePhotoUrl != null &&
                                _profilePhotoUrl!.isNotEmpty
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(_profilePhotoUrl!),
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.15),
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.gold, width: 2.5),
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _user?.displayName ?? 'User',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user?.email ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Settings Tiles ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Account'),
                    _settingsTile(
                      icon: Icons.person_outline_rounded,
                      iconColor: AppColors.primary,
                      title: 'Display Name',
                      subtitle: _user?.displayName ?? 'Not set',
                    ),
                    _settingsTile(
                      icon: Icons.email_outlined,
                      iconColor: AppColors.primary,
                      title: 'Email Address',
                      subtitle: _user?.email ?? 'Not set',
                    ),
                    _settingsTile(
                      icon: Icons.credit_card_rounded,
                      iconColor: AppColors.primary,
                      title: 'CNIC',
                      subtitle: _profileLoaded
                          ? (_cnic != null && _cnic!.isNotEmpty
                              ? _cnic!
                              : 'Not provided')
                          : 'Loading...',
                    ),
                    _settingsTile(
                      icon: Icons.school_outlined,
                      iconColor: AppColors.primary,
                      title: 'Intermediate Discipline',
                      subtitle: _profileLoaded
                          ? (_discipline != null && _discipline!.isNotEmpty
                              ? _discipline!
                              : 'Not selected')
                          : 'Loading...',
                    ),
                    _settingsTile(
                      icon: Icons.verified_user_outlined,
                      iconColor: (_user?.emailVerified ?? false)
                          ? Colors.green
                          : Colors.orange,
                      title: 'Email Verified',
                      subtitle: (_user?.emailVerified ?? false)
                          ? 'Your email is verified'
                          : 'Email not verified',
                      trailing: (_user?.emailVerified ?? false)
                          ? const Icon(Icons.check_circle,
                              color: Colors.green, size: 20)
                          : const Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 20),
                    ),

                    const SizedBox(height: 20),
                    _sectionLabel('App'),
                    _settingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.primaryLight,
                      title: 'App Version',
                      subtitle: '1.0.0',
                    ),
                    _settingsTile(
                      icon: Icons.school_outlined,
                      iconColor: AppColors.primaryLight,
                      title: 'About IAA',
                      subtitle: 'Intelligent Admission Assistant · UAF',
                    ),

                    const SizedBox(height: 32),

                    // ── Logout Button ─────────────────────────────────────
                    _isLoggingOut
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: _onLogout,
                              icon: const Icon(Icons.logout_rounded,
                                  color: Colors.white),
                              label: Text(
                                'Log Out',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade500,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                            ),
                          ),
                    const SizedBox(height: 12),

                    // Logged in as hint
                    Center(
                      child: Text(
                        'Logged in as ${_user?.email ?? ''}',
                        style: GoogleFonts.poppins(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _getInitials() {
    final name = _user?.displayName ?? _user?.email ?? '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          color: AppColors.textGrey,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
