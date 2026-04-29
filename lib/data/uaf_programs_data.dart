import 'package:flutter/material.dart';
import '../models/degree_program_model.dart';

/// All degree programs currently offered by UAF Burewala Campus.
/// Fee amounts are approximate representative values (PKR).
class UAFProgramsData {
  UAFProgramsData._();

  // ── Intermediate Disciplines ────────────────────────────────────────────
  static const List<String> intermediateDisciplines = [
    'FSc Pre-Engineering',
    'FSc Pre-Medical',
    'ICS',
    'FA',
    'ICom',
    'FSc Pre-Agricultural',
    'D.Com',
  ];

  // ── Category Colors ─────────────────────────────────────────────────────
  static const Color _techColor = Color(0xFF1E3A5F);

  static const Color _businessColor = Color(0xFF1A2E6B);
  static const Color _agriColor = Color(0xFF2D6A4F);
  static const Color _artsColor = Color(0xFF6D28D9);

  // ── All Programs ────────────────────────────────────────────────────────
  static const List<DegreeProgram> allPrograms = [
    // ─── Technology ───────────────────────────────────────────────────────
    DegreeProgram(
      code: 'BSSE',
      name: 'BS Software Engineering',
      category: 'Technology',
      bgColor: _techColor,
      shift: 'Morning',
      firstSemesterFee: 52000,
      subsequentFee: 40000,
      semesters: 8,
      scopeDescription:
          'BS Software Engineering focuses on the systematic design, development, testing, and maintenance of software systems. Graduates are equipped with skills in programming, software architecture, project management, and quality assurance.\n\n'
          'Career opportunities include roles as Software Engineers, Full-Stack Developers, DevOps Engineers, Mobile App Developers, System Architects, and Project Managers at leading tech companies, startups, and government IT departments.\n\n'
          'With the rapid growth of Pakistan\'s IT industry and increasing demand for skilled software professionals globally, BS Software Engineering graduates enjoy excellent employment prospects and competitive salaries both locally and internationally through freelancing and remote work opportunities.',
      eligibleDisciplines: ['FSc Pre-Engineering', 'ICS'],
    ),
    DegreeProgram(
      code: 'BSCS',
      name: 'BS Computer Science',
      category: 'Technology',
      bgColor: Color(0xFF1B4965),
      shift: 'Both',
      firstSemesterFee: 50000,
      subsequentFee: 38000,
      semesters: 8,
      scopeDescription:
          'BS Computer Science provides a deep foundation in computational theory, algorithms, data structures, artificial intelligence, machine learning, and database systems. The program emphasizes both theoretical knowledge and practical problem-solving skills.\n\n'
          'Graduates can pursue careers as Software Developers, Data Scientists, AI/ML Engineers, Cybersecurity Analysts, Database Administrators, and Research Scientists. The field offers diverse specialization paths including cloud computing, blockchain, and computer graphics.\n\n'
          'Computer Science remains one of the most in-demand disciplines worldwide, with graduates finding opportunities in multinational corporations, research institutions, tech startups, and academia. The growing digital transformation across all industries ensures sustained demand for CS professionals.',
      eligibleDisciplines: ['FSc Pre-Engineering', 'ICS'],
    ),
    DegreeProgram(
      code: 'BSIT',
      name: 'BS Information Technology',
      category: 'Technology',
      bgColor: Color(0xFF0B525B),
      shift: 'Both',
      firstSemesterFee: 48000,
      subsequentFee: 36000,
      semesters: 8,
      scopeDescription:
          'BS Information Technology bridges the gap between business needs and technological solutions. The program covers networking, web development, database management, IT infrastructure, cybersecurity, and enterprise systems.\n\n'
          'Career paths include IT Manager, Network Administrator, Systems Analyst, Web Developer, IT Consultant, Cloud Solutions Architect, and Technical Support Specialist. IT professionals are essential in every organization that relies on technology infrastructure.\n\n'
          'With the increasing digitization of businesses in Pakistan and worldwide, IT graduates find rewarding careers across banking, healthcare, education, telecommunications, and e-commerce sectors. The program also prepares students for globally recognized certifications like Cisco, AWS, and CompTIA.',
      eligibleDisciplines: ['FSc Pre-Engineering', 'ICS'],
    ),

    // ─── Business ─────────────────────────────────────────────────────────
    DegreeProgram(
      code: 'BBA',
      name: 'BBA (Hons)',
      category: 'Business',
      bgColor: _businessColor,
      shift: 'Both',
      firstSemesterFee: 42000,
      subsequentFee: 32000,
      semesters: 8,
      scopeDescription:
          'BBA (Hons) equips students with comprehensive knowledge in business administration, management principles, marketing, finance, human resource management, and organizational behavior. The program develops analytical thinking and leadership capabilities.\n\n'
          'Graduates can pursue careers as Business Analysts, Marketing Managers, Financial Advisors, HR Managers, Operations Managers, and Entrepreneurs. The degree provides a solid foundation for MBA programs and professional certifications like CFA and ACCA.\n\n'
          'With Pakistan\'s growing economy and expanding private sector, BBA graduates find opportunities in banks, multinational corporations, consulting firms, NGOs, and government organizations. The versatile nature of business education ensures career flexibility across diverse industries.',
      eligibleDisciplines: ['FA', 'FSc Pre-Engineering', 'FSc Pre-Medical', 'ICS', 'ICom', 'D.Com'],
    ),
    DegreeProgram(
      code: 'BBA-AB',
      name: 'BBA Agri-Business',
      category: 'Business',
      bgColor: Color(0xFF1E5631),
      shift: 'Morning',
      firstSemesterFee: 42000,
      subsequentFee: 32000,
      semesters: 8,
      scopeDescription:
          'BBA Agri-Business combines business management skills with agricultural knowledge, focusing on farm management, agricultural marketing, supply chain management, agri-finance, and rural enterprise development. It bridges the gap between agriculture and modern business practices.\n\n'
          'Career opportunities include Agri-Business Manager, Farm Operations Manager, Agricultural Marketing Specialist, Supply Chain Coordinator, Rural Development Officer, and Agricultural Commodity Trader. Graduates also find roles in food processing companies and agricultural policy organizations.\n\n'
          'Pakistan being an agricultural economy, there is immense potential for agri-business professionals. Graduates play a crucial role in modernizing agricultural practices, improving food supply chains, and contributing to rural economic development through innovative business solutions.',
      eligibleDisciplines: ['FA', 'FSc Pre-Engineering', 'FSc Pre-Medical', 'ICS', 'ICom', 'FSc Pre-Agricultural', 'D.Com'],
    ),

    // ─── Agriculture ──────────────────────────────────────────────────────
    DegreeProgram(
      code: 'BSc-Agri',
      name: 'BSc (Hons) Agriculture',
      category: 'Agriculture',
      bgColor: _agriColor,
      shift: 'Morning',
      firstSemesterFee: 35000,
      subsequentFee: 27000,
      semesters: 8,
      scopeDescription:
          'BSc (Hons) Agriculture provides comprehensive knowledge in crop sciences, soil science, plant pathology, entomology, agricultural economics, and farm management. Students learn modern agricultural techniques alongside traditional farming knowledge.\n\n'
          'Graduates can pursue careers as Agricultural Officers, Farm Managers, Agricultural Research Scientists, Extension Workers, Crop Consultants, and Agronomists. Government departments like Agriculture, Food, and Livestock offer significant employment opportunities.\n\n'
          'As Pakistan\'s economy heavily relies on agriculture contributing over 20% to GDP, trained agricultural professionals are in constant demand. Graduates also find opportunities in seed companies, fertilizer industries, pesticide companies, NGOs, and international agricultural organizations.',
      eligibleDisciplines: ['FSc Pre-Medical', 'FSc Pre-Engineering', 'FSc Pre-Agricultural'],
    ),

    // ─── Science ──────────────────────────────────────────────────────────
    DegreeProgram(
      code: 'BS-Math',
      name: 'BS Mathematics',
      category: 'Science',
      bgColor: Color(0xFF3C1874),
      shift: 'Morning',
      firstSemesterFee: 38000,
      subsequentFee: 28000,
      semesters: 8,
      scopeDescription:
          'BS Mathematics provides rigorous training in pure and applied mathematics, including algebra, calculus, statistics, numerical analysis, and mathematical modeling. The program develops strong analytical and problem-solving capabilities.\n\n'
          'Career paths include Mathematician, Statistician, Data Analyst, Actuarial Scientist, Operations Research Analyst, and Mathematics Teacher. Graduates also find excellent opportunities in banking, insurance, finance, and technology sectors.\n\n'
          'Mathematics graduates are among the most versatile professionals, with their analytical skills valued across industries. The program also provides an excellent foundation for advanced studies in mathematics, computer science, economics, and engineering.',
      eligibleDisciplines: ['FSc Pre-Engineering', 'ICS'],
    ),
    DegreeProgram(
      code: 'BS-Chem',
      name: 'BS Chemistry',
      category: 'Science',
      bgColor: Color(0xFF5B2C6F),
      shift: 'Morning',
      firstSemesterFee: 40000,
      subsequentFee: 30000,
      semesters: 8,
      scopeDescription:
          'BS Chemistry covers organic, inorganic, physical, and analytical chemistry with extensive laboratory training. Students develop skills in chemical analysis, synthesis, instrumentation, and quality control techniques.\n\n'
          'Career opportunities include Chemist, Quality Control Analyst, Lab Technician, Pharmaceutical Researcher, Environmental Scientist, and Food Safety Inspector. Graduates are employed in pharmaceutical companies, chemical industries, food processing units, and research laboratories.\n\n'
          'With Pakistan\'s growing industrial sector, chemistry graduates find opportunities in textile, pharmaceutical, cement, fertilizer, and petroleum industries. The program also prepares students for advanced research in chemistry and related interdisciplinary fields.',
      eligibleDisciplines: ['FSc Pre-Medical', 'FSc Pre-Engineering'],
    ),
    DegreeProgram(
      code: 'BS-Bot',
      name: 'BS Botany',
      category: 'Science',
      bgColor: Color(0xFF1B5E20),
      shift: 'Morning',
      firstSemesterFee: 38000,
      subsequentFee: 28000,
      semesters: 8,
      scopeDescription:
          'BS Botany explores the science of plant life, covering plant physiology, taxonomy, ecology, genetics, microbiology, and biotechnology. Students gain hands-on experience through fieldwork and laboratory research.\n\n'
          'Career paths include Botanist, Plant Pathologist, Ecologist, Conservation Scientist, Agricultural Research Officer, and Environmental Consultant. Graduates find employment in agriculture departments, botanical gardens, environmental agencies, and research institutions.\n\n'
          'With growing concerns about food security, climate change, and biodiversity conservation, botany graduates play an increasingly important role. The field offers opportunities in plant breeding, genetic engineering, medicinal plant research, and sustainable agriculture development.',
      eligibleDisciplines: ['FSc Pre-Medical'],
    ),
    DegreeProgram(
      code: 'BS-Zool',
      name: 'BS Zoology',
      category: 'Science',
      bgColor: Color(0xFF4A148C),
      shift: 'Morning',
      firstSemesterFee: 38000,
      subsequentFee: 28000,
      semesters: 8,
      scopeDescription:
          'BS Zoology provides comprehensive understanding of animal biology, including animal physiology, genetics, ecology, entomology, parasitology, and wildlife management. The program combines theoretical knowledge with practical laboratory and field experience.\n\n'
          'Career opportunities include Zoologist, Wildlife Biologist, Entomologist, Fisheries Officer, Lab Researcher, and Environmental Impact Assessment Specialist. Government wildlife departments and conservation organizations actively recruit zoology graduates.\n\n'
          'Zoology graduates contribute to wildlife conservation, fisheries management, pest control, and biomedical research. With increasing emphasis on biodiversity preservation and environmental protection in Pakistan, the demand for trained zoologists continues to grow across public and private sectors.',
      eligibleDisciplines: ['FSc Pre-Medical'],
    ),
    DegreeProgram(
      code: 'BS-HND',
      name: 'BS Human Nutrition & Dietetics',
      category: 'Science',
      bgColor: Color(0xFFBF360C),
      shift: 'Morning',
      firstSemesterFee: 45000,
      subsequentFee: 34000,
      semesters: 8,
      scopeDescription:
          'BS Human Nutrition & Dietetics focuses on food science, clinical nutrition, public health nutrition, dietotherapy, and nutritional biochemistry. Students learn to assess nutritional needs and design dietary plans for individuals and communities.\n\n'
          'Graduates can pursue careers as Clinical Nutritionists, Dietitians, Public Health Nutritionists, Food Safety Officers, Sports Nutritionists, and Nutrition Researchers. Hospitals, clinics, food industries, and sports organizations actively seek qualified nutritionists.\n\n'
          'With rising health consciousness and increasing prevalence of lifestyle diseases in Pakistan, the demand for qualified nutritionists is growing rapidly. Graduates also find opportunities in NGOs, international health organizations, research institutions, and the expanding wellness and fitness industry.',
      eligibleDisciplines: ['FSc Pre-Medical'],
    ),
    DegreeProgram(
      code: 'BS-FST',
      name: 'BS Food Science & Technology',
      category: 'Science',
      bgColor: Color(0xFFE65100),
      shift: 'Morning',
      firstSemesterFee: 45000,
      subsequentFee: 34000,
      semesters: 8,
      scopeDescription:
          'BS Food Science & Technology covers food chemistry, food microbiology, food processing, preservation techniques, quality assurance, and food safety regulations. Students gain practical skills through lab work and industrial visits.\n\n'
          'Career paths include Food Technologist, Quality Assurance Manager, Food Safety Officer, Product Development Specialist, Food Processing Engineer, and Regulatory Affairs Officer. The food industry offers diverse employment opportunities at every level.\n\n'
          'Pakistan\'s expanding food processing industry creates constant demand for food science graduates. With growing emphasis on food safety standards, export quality, and value-added food products, graduates find excellent opportunities in multinational food companies, dairy industries, beverage companies, and government food authorities.',
      eligibleDisciplines: ['FSc Pre-Medical', 'FSc Pre-Engineering'],
    ),

    // ─── Arts & Social ────────────────────────────────────────────────────
    DegreeProgram(
      code: 'BS-Eng',
      name: 'BS English Language & Literature',
      category: 'Arts & Social',
      bgColor: _artsColor,
      shift: 'Morning',
      firstSemesterFee: 36000,
      subsequentFee: 26000,
      semesters: 8,
      scopeDescription:
          'BS English Language & Literature develops proficiency in English communication, literary analysis, creative writing, linguistics, and critical thinking. The program covers British, American, and Postcolonial literatures alongside practical language skills.\n\n'
          'Career opportunities include English Teacher/Lecturer, Content Writer, Translator, Journalist, Public Relations Officer, Copy Editor, and Communications Specialist. Media houses, educational institutions, and corporate communications departments actively recruit English graduates.\n\n'
          'In Pakistan\'s increasingly globalized economy, strong English proficiency is a valuable asset across all professional fields. Graduates find opportunities in education, media, publishing, advertising, digital content creation, and international organizations. The degree also serves as excellent preparation for CSS/PMS competitive examinations.',
      eligibleDisciplines: ['FA', 'FSc Pre-Engineering', 'FSc Pre-Medical', 'ICS', 'ICom'],
    ),
    DegreeProgram(
      code: 'BS-Socio',
      name: 'BS Sociology',
      category: 'Arts & Social',
      bgColor: Color(0xFF7B1FA2),
      shift: 'Evening',
      firstSemesterFee: 36000,
      subsequentFee: 26000,
      semesters: 8,
      scopeDescription:
          'BS Sociology examines human society, social institutions, cultural norms, social change, and community dynamics. The program develops research skills, critical analysis, and understanding of social issues affecting Pakistan and the world.\n\n'
          'Career paths include Social Researcher, Community Development Officer, NGO Program Coordinator, Social Welfare Officer, Policy Analyst, and Human Rights Advocate. Graduates find roles in development organizations, government social welfare departments, and research institutions.\n\n'
          'With Pakistan facing numerous social challenges including poverty, education inequality, and health disparities, trained sociologists are increasingly important. Graduates contribute to social policy development, community empowerment programs, and humanitarian initiatives through local and international organizations.',
      eligibleDisciplines: ['FA', 'FSc Pre-Engineering', 'FSc Pre-Medical'],
    ),
  ];

  // ── Helper Methods ──────────────────────────────────────────────────────

  static List<String> getAllCategories() {
    return ['All', ...allPrograms.map((p) => p.category).toSet()];
  }

  static List<DegreeProgram> getProgramsByCategory(String category) {
    if (category == 'All') return allPrograms;
    return allPrograms.where((p) => p.category == category).toList();
  }

  static List<DegreeProgram> getProgramsByDiscipline(String discipline) {
    return allPrograms
        .where((p) => p.eligibleDisciplines.contains(discipline))
        .toList();
  }

  static List<DegreeProgram> searchPrograms(String query) {
    final q = query.toLowerCase();
    return allPrograms
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.code.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }
}
