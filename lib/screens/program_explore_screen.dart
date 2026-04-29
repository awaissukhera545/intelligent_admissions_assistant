import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../data/uaf_programs_data.dart';
import '../models/degree_program_model.dart';
import 'degree_detail_screen.dart';

class ProgramExploreScreen extends StatefulWidget {
  const ProgramExploreScreen({super.key});

  @override
  State<ProgramExploreScreen> createState() => _ProgramExploreScreenState();
}

class _ProgramExploreScreenState extends State<ProgramExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<DegreeProgram> _filteredPrograms = UAFProgramsData.allPrograms;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPrograms() {
    final query = _searchController.text.trim();
    setState(() {
      List<DegreeProgram> programs;
      if (_selectedCategory == 'All') {
        programs = UAFProgramsData.allPrograms;
      } else {
        programs = UAFProgramsData.getProgramsByCategory(_selectedCategory);
      }
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        programs = programs
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.code.toLowerCase().contains(q))
            .toList();
      }
      _filteredPrograms = programs;
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
                    'Explore Programs',
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

            // ── Search Bar ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterPrograms(),
                  style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    hintStyle: GoogleFonts.poppins(
                        color: AppColors.textGrey, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textGrey, size: 22),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Category Chips ────────────────────────────────────
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: UAFProgramsData.getAllCategories().map((cat) {
                  final selected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) {
                        _selectedCategory = cat;
                        _filterPrograms();
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textDark,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // ── Program Grid ──────────────────────────────────────
            Expanded(
              child: _filteredPrograms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 64, color: AppColors.textGrey.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No programs found',
                            style: GoogleFonts.poppins(
                                color: AppColors.textGrey, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: _filteredPrograms.length,
                      itemBuilder: (context, index) {
                        final p = _filteredPrograms[index];
                        return _ProgramCard(
                          program: p,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DegreeDetailScreen(program: p),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Program Card Widget ─────────────────────────────────────────────────────

class _ProgramCard extends StatelessWidget {
  final DegreeProgram program;
  final VoidCallback onTap;

  const _ProgramCard({required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top color area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: program.bgColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: -10,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Code text
                    Center(
                      child: Text(
                        program.code,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    // Shift badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _shiftColor(program.shift),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          program.shift,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom info area
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      program.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.category,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
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

  Color _shiftColor(String shift) {
    switch (shift) {
      case 'Morning':
        return AppColors.morningBadge;
      case 'Evening':
        return AppColors.eveningBadge;
      case 'Both':
        return AppColors.bothBadge;
      default:
        return AppColors.textGrey;
    }
  }
}
