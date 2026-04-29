import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../data/uaf_programs_data.dart';
import '../models/degree_program_model.dart';
import 'degree_detail_screen.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen>
    with SingleTickerProviderStateMixin {
  // Toggle: 0 = Eligibility, 1 = Aggregate Calculator
  int _activeTab = 0;

  // ── Eligibility tab state ───────────────────────────────────────────────
  String? _selectedDiscipline;
  List<DegreeProgram> _eligiblePrograms = [];
  bool _showResults = false;

  // ── Aggregate tab state ─────────────────────────────────────────────────
  final _matricObtainedCtrl = TextEditingController();
  final _matricTotalCtrl = TextEditingController(text: '1100');
  final _interFirstCtrl = TextEditingController();
  final _interSecondCtrl = TextEditingController();
  final _entryTestCtrl = TextEditingController();
  double? _aggregate;
  bool _showAggregate = false;

  @override
  void dispose() {
    _matricObtainedCtrl.dispose();
    _matricTotalCtrl.dispose();
    _interFirstCtrl.dispose();
    _interSecondCtrl.dispose();
    _entryTestCtrl.dispose();
    super.dispose();
  }

  void _findEligiblePrograms() {
    if (_selectedDiscipline == null) return;
    setState(() {
      _eligiblePrograms =
          UAFProgramsData.getProgramsByDiscipline(_selectedDiscipline!);
      _showResults = true;
    });
  }

  void _calculateAggregate() {
    final matricObt = double.tryParse(_matricObtainedCtrl.text) ?? 0;
    final matricTotal = double.tryParse(_matricTotalCtrl.text) ?? 1100;
    final interFirst = double.tryParse(_interFirstCtrl.text) ?? 0;
    final interSecond = double.tryParse(_interSecondCtrl.text);
    final entryTest = double.tryParse(_entryTestCtrl.text) ?? 0;

    // Inter marks: if second year available, use total (first+second)/1100
    // otherwise use first year only out of 550
    double interPercent;
    if (interSecond != null && interSecond > 0) {
      interPercent = ((interFirst + interSecond) / 1100) * 100;
    } else {
      interPercent = (interFirst / 550) * 100;
    }

    final matricPercent = (matricObt / matricTotal) * 100;
    final entryPercent = (entryTest / 100) * 100; // entry test assumed out of 100

    // Formula: 30% Matric + 30% Inter + 40% Entry Test
    final aggregate =
        (0.30 * matricPercent) + (0.30 * interPercent) + (0.40 * entryPercent);

    setState(() {
      _aggregate = aggregate.clamp(0, 100);
      _showAggregate = true;
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
                    'Eligibility & Calculator',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Toggle Switch ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildToggleTab('Eligibility of Degree', 0),
                    _buildToggleTab('Aggregate Calculator', 1),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab Content ───────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _activeTab == 0
                    ? _buildEligibilityTab()
                    : _buildAggregateTab(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTab(String label, int index) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── ELIGIBILITY TAB ───────────────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildEligibilityTab() {
    return SingleChildScrollView(
      key: const ValueKey('eligibility'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your Intermediate Discipline',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          // Dropdown + Enter button row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.divider),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDiscipline,
                      hint: Text(
                        'Select discipline',
                        style: GoogleFonts.poppins(
                            color: AppColors.textGrey, fontSize: 13),
                      ),
                      items: UAFProgramsData.intermediateDisciplines
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text(
                                  d,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.textDark),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedDiscipline = val),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _findEligiblePrograms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  'Find',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Results
          if (_showResults) ...[
            Text(
              '${_eligiblePrograms.length} Programs Available',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on $_selectedDiscipline',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 14),
            if (_eligiblePrograms.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.textGrey.withValues(alpha: 0.5),
                        size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No programs found for this discipline',
                      style: GoogleFonts.poppins(
                          color: AppColors.textGrey, fontSize: 14),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(_eligiblePrograms.length, (i) {
                final p = _eligiblePrograms[i];
                return _EligibleProgramTile(
                  program: p,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DegreeDetailScreen(program: p),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ── AGGREGATE CALCULATOR TAB ──────────────────────────────────────────────
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildAggregateTab() {
    return SingleChildScrollView(
      key: const ValueKey('aggregate'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formula info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryPale),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Formula: 30% Matric + 30% Inter + 40% Entry Test',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Matric section
          _sectionLabel('Matric / SSC Marks'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _calcField('Obtained', _matricObtainedCtrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _calcField('Total Marks', _matricTotalCtrl),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Inter section
          _sectionLabel('Intermediate / HSSC Marks'),
          const SizedBox(height: 8),
          _calcField('First Year Marks (out of 550)', _interFirstCtrl),
          const SizedBox(height: 10),
          _calcField(
              'Second Year Marks (if declared, out of 550)', _interSecondCtrl),

          const SizedBox(height: 20),

          // Entry Test section
          _sectionLabel('Entry Test Marks'),
          const SizedBox(height: 8),
          _calcField('Marks Obtained (out of 100)', _entryTestCtrl),

          const SizedBox(height: 24),

          // Calculate button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _calculateAggregate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                'Calculate Aggregate',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Result
          if (_showAggregate && _aggregate != null)
            _buildAggregateResult(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAggregateResult() {
    final agg = _aggregate!;
    Color resultColor;
    String remark;
    if (agg >= 80) {
      resultColor = const Color(0xFF16A34A);
      remark = 'Excellent! You have a strong aggregate.';
    } else if (agg >= 60) {
      resultColor = AppColors.morningBadge;
      remark = 'Good! You have a competitive aggregate.';
    } else if (agg >= 45) {
      resultColor = AppColors.gold;
      remark = 'Fair. You may qualify for some programs.';
    } else {
      resultColor = Colors.red.shade500;
      remark = 'Below minimum threshold for most programs.';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            resultColor.withValues(alpha: 0.1),
            resultColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: resultColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Your Aggregate',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${agg.toStringAsFixed(2)}%',
            style: GoogleFonts.poppins(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: resultColor,
            ),
          ),
          const SizedBox(height: 6),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: agg / 100,
                backgroundColor: resultColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(resultColor),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            remark,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: resultColor,
            ),
          ),

          const SizedBox(height: 16),

          // Breakdown
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _breakdownRow('Matric (30%)',
                    _calcPercentContribution(_matricObtainedCtrl.text, _matricTotalCtrl.text, 0.30)),
                const Divider(height: 12),
                _breakdownRow('Inter (30%)',
                    _calcInterContribution()),
                const Divider(height: 12),
                _breakdownRow('Entry Test (40%)',
                    _calcPercentContribution(_entryTestCtrl.text, '100', 0.40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calcPercentContribution(String obtained, String total, double weight) {
    final obt = double.tryParse(obtained) ?? 0;
    final tot = double.tryParse(total) ?? 1;
    final percent = (obt / tot) * 100;
    final contribution = percent * weight;
    return '${percent.toStringAsFixed(1)}% × ${(weight * 100).toInt()}% = ${contribution.toStringAsFixed(2)}%';
  }

  String _calcInterContribution() {
    final first = double.tryParse(_interFirstCtrl.text) ?? 0;
    final second = double.tryParse(_interSecondCtrl.text);
    double percent;
    if (second != null && second > 0) {
      percent = ((first + second) / 1100) * 100;
    } else {
      percent = (first / 550) * 100;
    }
    final contribution = percent * 0.30;
    return '${percent.toStringAsFixed(1)}% × 30% = ${contribution.toStringAsFixed(2)}%';
  }

  Widget _breakdownRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _calcField(String hint, TextEditingController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 13),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

// ── Eligible Program Tile ───────────────────────────────────────────────────

class _EligibleProgramTile extends StatelessWidget {
  final DegreeProgram program;
  final VoidCallback onTap;

  const _EligibleProgramTile({required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: program.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  program.code.length > 4
                      ? program.code.substring(0, 4)
                      : program.code,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${program.category} · ${program.shift}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textGrey, size: 22),
          ],
        ),
      ),
    );
  }
}
