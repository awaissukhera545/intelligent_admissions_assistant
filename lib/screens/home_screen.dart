import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../data/uaf_programs_data.dart';
import '../models/degree_program_model.dart';
import '../models/notification_model.dart';
import 'settings_screen.dart';
import 'program_explore_screen.dart';
import 'degree_detail_screen.dart';
import 'eligibility_screen.dart';
import 'application_tracker_screen.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  String _selectedCategory = 'All';
  String? _profilePhotoUrl;

  // Quick Actions use Image Assets
  static const List<_QuickActionItem> _quickActions = [
    _QuickActionItem(
        imagePath: 'assets/images/search.png', label: 'Program\nSearch'),
    _QuickActionItem(
        imagePath: 'assets/images/calc.png', label: 'Eligibility\nCalculator'),
    _QuickActionItem(
        imagePath: 'assets/images/app_track.png',
        label: 'Application\nTracker'),
    _QuickActionItem(
        imagePath: 'assets/images/chat_icon.png', label: 'Chat with\n AI'),
  ];

  // Notification items (replacing deadlines)
  static const List<NotificationItem> _notifications = [
    NotificationItem(
      title: '1st Merit List Uploaded',
      description: 'Check your admission status now',
      time: '2 hours ago',
      icon: Icons.format_list_numbered_rounded,
      iconColor: AppColors.statusGreen,
      isNew: true,
    ),
    NotificationItem(
      title: 'Entry Test Results Declared',
      description: 'View your marks in Application Tracker',
      time: 'Yesterday',
      icon: Icons.assignment_turned_in_rounded,
      iconColor: AppColors.morningBadge,
      isNew: true,
    ),
    NotificationItem(
      title: 'Classes Commenced',
      description: 'Fall 2026 session has officially begun',
      time: '3 days ago',
      icon: Icons.school_rounded,
      iconColor: AppColors.primary,
      isNew: false,
    ),
    NotificationItem(
      title: 'Admissions Open',
      description: 'Apply before Aug 15, 2026 deadline',
      time: '1 week ago',
      icon: Icons.campaign_rounded,
      iconColor: AppColors.gold,
      isNew: false,
    ),
  ];

  // Bottom Nav uses Material Icons
  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.explore_outlined, label: 'Explore'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'AI Assistant'),
    _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists && mounted) {
        final data = doc.data();
        if (data != null && data['profilePhotoUrl'] != null) {
          setState(() {
            _profilePhotoUrl = data['profilePhotoUrl'] as String?;
          });
        }
      }
    } catch (_) {
      // Silently fail — profile photo is optional
    }
  }

  List<DegreeProgram> get _filteredPrograms {
    return UAFProgramsData.getProgramsByCategory(_selectedCategory);
  }

  // ── Quick Action Navigation ─────────────────────────────────────────────
  void _onQuickAction(int index) {
    switch (index) {
      case 0: // Program Search
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ProgramExploreScreen()));
        break;
      case 1: // Eligibility Calculator
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EligibilityScreen()));
        break;
      case 2: // Application Tracker
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ApplicationTrackerScreen()));
        break;
      case 3: // Chat with AI
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AIChatScreen()));
        break;
    }
  }

  // ── Bottom Nav Handler ──────────────────────────────────────────────────
  void _onNavTap(int index) {
    if (index == 1) {
      // Explore → push ProgramExploreScreen
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ProgramExploreScreen()));
      return;
    }
    if (index == 2) {
      // AI Assistant → push AIChatScreen
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AIChatScreen()));
      return;
    }
    setState(() => _selectedNavIndex = index);
  }

  // ── Body Logic ────────────────────────────────────────────────────────────
  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 3:
        return const SettingsScreen();
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildSectionHeader('Offered Programs', showFilter: true),
              const SizedBox(height: 12),
              _buildProgramCards(),
              const SizedBox(height: 24),
              _buildSectionHeader('Latest Updates', showFilter: false),
              const SizedBox(height: 12),
              _buildNotifications(),
              const SizedBox(height: 16),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (_selectedNavIndex != 3) ...[
              _buildAppBar(),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
            ],
            Expanded(child: _buildBody()),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ─────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    final user = FirebaseAuth.instance.currentUser;
    final initials = _getInitials(user?.displayName ?? user?.email ?? '?');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/appbar_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Intelligent Admissions Assistant',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _selectedNavIndex = 3),
            child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                ? CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(_profilePhotoUrl!),
                    backgroundColor: AppColors.primaryPale,
                  )
                : CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      initials,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildWelcomeBanner() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email ?? 'User';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, $name!',
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Ready to explore your future!',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  // ── Quick Actions ─────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      children: List.generate(_quickActions.length, (index) {
        final action = _quickActions[index];
        return Expanded(
          child: GestureDetector(
            onTap: () => _onQuickAction(index),
            child: Container(
              margin: EdgeInsets.only(
                  right: index < _quickActions.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(action.imagePath, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        height: 1.1),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {required bool showFilter}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        if (showFilter)
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryPale),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list_rounded,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _selectedCategory == 'All' ? 'Filter' : _selectedCategory,
                    style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showFilterSheet() {
    final categories = UAFProgramsData.getAllCategories();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Filter by Category',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              selected ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Program Cards ─────────────────────────────────────────────────────
  Widget _buildProgramCards() {
    final programs = _filteredPrograms;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final p = programs[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DegreeDetailScreen(program: p),
              ),
            ),
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8)
                  ]),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: p.bgColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16))),
                      child: Stack(
                        children: [
                          // Decorative circle
                          Positioned(
                            top: -10,
                            right: -10,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(p.code,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800)),
                          ),
                          // Shift badge
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: p.shift == 'Morning'
                                    ? AppColors.morningBadge
                                    : p.shift == 'Evening'
                                        ? AppColors.eveningBadge
                                        : AppColors.bothBadge,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                p.shift,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(p.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Notifications (Replacing Deadlines) ─────────────────────────────────
  Widget _buildNotifications() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6)
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: n.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(n.icon, color: n.iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (n.isNew)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        n.description,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  n.time,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.divider, width: 1))),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          // For Explore (1) and AI Assistant (2), they push new screens
          // so they are never visually "selected" — only Home and Settings are
          final selected = index == _selectedNavIndex &&
              (index == 0 || index == 3);
          return GestureDetector(
            onTap: () => _onNavTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 26,
                  color: selected ? AppColors.primary : AppColors.textGrey,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: selected ? AppColors.primary : AppColors.textGrey,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Private Data Classes ────────────────────────────────────────────────────

class _QuickActionItem {
  final String imagePath;
  final String label;
  const _QuickActionItem({required this.imagePath, required this.label});
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
