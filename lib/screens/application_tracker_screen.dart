import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';


class ApplicationTrackerScreen extends StatefulWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  State<ApplicationTrackerScreen> createState() =>
      _ApplicationTrackerScreenState();
}

class _ApplicationTrackerScreenState extends State<ApplicationTrackerScreen> {
  // ── Mock Data ───────────────────────────────────────────────────────────
  // Stage statuses: 'completed', 'active', 'pending'
  final String _admissionStatus = 'completed';
  final String _admissionDate = 'Aug 15, 2026';

  final String _entryTestStatus = 'completed';
  final String _entryTestDate = 'Sep 5, 2026';

  final String _meritListStatus = 'active'; // active means in progress

  // Entry test result lookup
  final _rollNumberCtrl = TextEditingController();
  Map<String, String>? _entryTestResult;

  // Merit list
  String? _selectedDegreeForMerit;
  final List<String> _degreesWithResults = [
    'BS Computer Science',
    'BS Information Technology',
    'BS Software Engineering',
  ];

  // Mock merit data
  final List<_MeritListData> _meritLists = [
    _MeritListData(
      title: '1st Merit List',
      status: 'displayed',
      date: 'Sep 20, 2026',
      meritCutoff: 78.5,
    ),
    _MeritListData(
      title: '2nd Merit List',
      status: 'displayed',
      date: 'Sep 28, 2026',
      meritCutoff: 72.3,
    ),
    _MeritListData(
      title: '3rd Merit List',
      status: 'pending',
      date: 'Expected: Oct 5, 2026',
      meritCutoff: null,
    ),
  ];

  // User mock aggregate
  final double _userAggregate = 65.4;
  bool _isSelected = false; // whether user got selected
  final String _selectedInList = '2nd Merit List';

  @override
  void dispose() {
    _rollNumberCtrl.dispose();
    super.dispose();
  }

  void _checkEntryTestResult() {
    final roll = _rollNumberCtrl.text.trim();
    if (roll.isEmpty) return;

    // Mock result - in real app, this would be an API call
    setState(() {
      _entryTestResult = {
        'rollNumber': roll,
        'name': 'Ahmed Khan',
        'marks': '72 / 100',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textDark),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Application Tracker',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Timeline ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Stage 1: Admissions
                    _buildStage(
                      stageNumber: 1,
                      title: 'Admissions Started',
                      status: _admissionStatus,
                      isLast: false,
                      child: _buildAdmissionContent(),
                    ),

                    // Stage 2: Entry Test
                    _buildStage(
                      stageNumber: 2,
                      title: 'Entry Test',
                      status: _entryTestStatus,
                      isLast: false,
                      child: _buildEntryTestContent(),
                    ),

                    // Stage 3: Merit Lists
                    _buildStage(
                      stageNumber: 3,
                      title: 'Merit Lists',
                      status: _meritListStatus,
                      isLast: true,
                      child: _buildMeritListContent(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── STAGE BUILDER ─────────────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStage({
    required int stageNumber,
    required String title,
    required String status,
    required bool isLast,
    required Widget child,
  }) {
    Color bgColor, borderColor, dotColor;
    IconData dotIcon;

    switch (status) {
      case 'completed':
        bgColor = AppColors.statusGreenBg;
        borderColor = AppColors.statusGreen.withValues(alpha: 0.3);
        dotColor = AppColors.statusGreen;
        dotIcon = Icons.check_circle_rounded;
        break;
      case 'active':
        bgColor = AppColors.statusAmberBg;
        borderColor = AppColors.statusAmber.withValues(alpha: 0.3);
        dotColor = AppColors.statusAmber;
        dotIcon = Icons.pending_rounded;
        break;
      default: // pending
        bgColor = AppColors.statusGreyBg;
        borderColor = AppColors.statusGrey.withValues(alpha: 0.2);
        dotColor = AppColors.statusGrey;
        dotIcon = Icons.radio_button_unchecked_rounded;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Icon(dotIcon, color: dotColor, size: 28),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2.5,
                      color: dotColor.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Stage card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      if (status == 'completed')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Completed',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statusGreen,
                            ),
                          ),
                        ),
                      if (status == 'active')
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusAmber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'In Progress',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.statusAmber,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── STAGE 1: ADMISSIONS ───────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildAdmissionContent() {
    return Row(
      children: [
        Icon(Icons.calendar_today_rounded,
            color: AppColors.statusGreen, size: 18),
        const SizedBox(width: 8),
        Text(
          'Admissions started on $_admissionDate',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── STAGE 2: ENTRY TEST ───────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildEntryTestContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                color: AppColors.statusGreen, size: 18),
            const SizedBox(width: 8),
            Text(
              '$_entryTestDate  ',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.statusGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '(Conducted)',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statusGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Roll number check
        Text(
          'Check your entry test marks',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: TextField(
                  controller: _rollNumberCtrl,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Enter Roll Number',
                    hintStyle: GoogleFonts.poppins(
                        color: AppColors.textGrey, fontSize: 12),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: _checkEntryTestResult,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  'Check',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Result display
        if (_entryTestResult != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _resultRow(
                    'Roll No.', _entryTestResult!['rollNumber']!),
                const SizedBox(height: 6),
                _resultRow('Name', _entryTestResult!['name']!),
                const SizedBox(height: 6),
                _resultRow('Marks', _entryTestResult!['marks']!),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _resultRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── STAGE 3: MERIT LISTS ──────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMeritListContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Degree dropdown
        Text(
          'Select Degree Program',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDegreeForMerit,
              hint: Text(
                'Choose program',
                style: GoogleFonts.poppins(
                    color: AppColors.textGrey, fontSize: 12),
              ),
              items: _degreesWithResults
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textDark)),
                      ))
                  .toList(),
              onChanged: (val) => setState(
                  () => _selectedDegreeForMerit = val),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Merit lists
        if (_selectedDegreeForMerit != null)
          ...List.generate(_meritLists.length, (i) {
            final merit = _meritLists[i];
            return _buildMeritListItem(merit, i);
          }),

        if (_selectedDegreeForMerit == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(Icons.format_list_numbered_rounded,
                    color: AppColors.textGrey.withValues(alpha: 0.4),
                    size: 36),
                const SizedBox(height: 8),
                Text(
                  'Select a program to view merit lists',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),

        // Congratulations card if selected
        if (_selectedDegreeForMerit != null && _isSelected) ...[
          const SizedBox(height: 16),
          _buildCongratulationsCard(),
        ],
      ],
    );
  }

  Widget _buildMeritListItem(_MeritListData merit, int index) {
    final isDisplayed = merit.status == 'displayed';
    Color itemBg, itemBorder;
    if (isDisplayed) {
      itemBg = AppColors.statusGreenBg;
      itemBorder = AppColors.statusGreen.withValues(alpha: 0.2);
    } else {
      itemBg = AppColors.statusGreyBg;
      itemBorder = AppColors.statusGrey.withValues(alpha: 0.2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: itemBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      merit.title,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (isDisplayed) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.statusGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '(Displayed)',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.statusGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isDisplayed)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Downloading ${merit.title}...',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.download_rounded,
                        color: AppColors.primary, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            merit.date,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isDisplayed && merit.meritCutoff != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _meritBadge('Merit falls at',
                    '${merit.meritCutoff!.toStringAsFixed(1)}%',
                    AppColors.statusGreen),
                const SizedBox(width: 10),
                _meritBadge('Your aggregate',
                    '${_userAggregate.toStringAsFixed(1)}%',
                    _userAggregate >= merit.meritCutoff!
                        ? AppColors.statusGreen
                        : AppColors.statusAmber),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _meritBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratulationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.statusGreen.withValues(alpha: 0.1),
            AppColors.statusGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: AppColors.statusGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.celebration_rounded,
                  color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Congratulations! 🎉',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.statusGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You have been selected in $_selectedInList for $_selectedDegreeForMerit!',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _detailRow('Sr. No', '142'),
          _detailRow('Application No', 'UAF-BWL-2026-0854'),
          _detailRow('Aggregate', '${_userAggregate.toStringAsFixed(2)}%'),
          _detailRow('Candidate Name', 'Ahmed Khan'),
          _detailRow('Father Name', 'Muhammad Khan'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Merit List Data Model (Private) ─────────────────────────────────────────

class _MeritListData {
  final String title;
  final String status; // 'displayed', 'pending'
  final String date;
  final double? meritCutoff;

  const _MeritListData({
    required this.title,
    required this.status,
    required this.date,
    this.meritCutoff,
  });
}
