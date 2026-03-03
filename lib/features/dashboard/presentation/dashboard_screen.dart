import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../data/risk_service.dart';
import '../providers/location_risk_provider.dart';
import 'learn_screen.dart';
import 'alerts_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(theme),
          const LearnScreen(),
          const AlertsScreen(),
          const Center(child: Text('Profile (Coming Soon)')),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/chat'),
              backgroundColor: AppColors.indigo,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: Text(
                'Ask AI',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(theme),
    );
  }

  Widget _buildHomeTab(ThemeData theme) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildGreetingHeader(theme),
            const SizedBox(height: 24),
            _buildResilienceScoreCard(theme),
            const SizedBox(height: 20),
            _buildAlertBanner(theme),
            const SizedBox(height: 28),
            Text('Disaster Modules', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Choose a topic to focus on',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildModulesGrid(context, theme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Greeting Header ────────────────────────────────────────────────
  Widget _buildGreetingHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, User',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
        ),
        // Profile avatar
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  // ── Resilience Score Card ──────────────────────────────────────────
  Widget _buildResilienceScoreCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Score circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '65',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resilience Score',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level 2: Prepared',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 8),
                // Mini progress pills
                Row(
                  children: List.generate(5, (i) {
                    return Expanded(
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: i < 3
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white70,
            size: 18,
          ),
        ],
      ),
    );
  }

  // ── Alert Banner ──────────────────────────────────────────────────
  Widget _buildAlertBanner(ThemeData theme) {
    final riskState = ref.watch(locationRiskProvider);

    Color bgColor = AppColors.coral.withValues(alpha: 0.15);
    Color borderColor = AppColors.coral.withValues(alpha: 0.3);
    Color iconColor = const Color(0xFFE65100);
    IconData iconData = Icons.warning_amber_rounded;
    String titleText = 'Location Risk Level';
    String subtitleText = 'Fetching local data...';
    Color titleColor = const Color(0xFFBF360C);

    if (riskState.isLoading) {
      subtitleText = 'Detecting location...';
      iconData = Icons.sync;
      iconColor = AppColors.indigo;
      bgColor = AppColors.indigo.withValues(alpha: 0.1);
      borderColor = AppColors.indigo.withValues(alpha: 0.2);
      titleColor = AppColors.indigo;
    } else if (riskState.error != null) {
      titleText = 'Location Unavailable';
      subtitleText = riskState.error!;
      iconData = Icons.location_disabled;
      iconColor = Colors.grey.shade700;
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
      titleColor = Colors.grey.shade800;
    } else if (riskState.assessment != null) {
      final assessment = riskState.assessment!;
      final locality = riskState.locality ?? 'Unknown Location';
      titleText = 'Risk Level: ${assessment.level.name.toUpperCase()}';
      subtitleText = '$locality — ${assessment.message}';

      switch (assessment.level) {
        case RiskLevel.low:
          bgColor = Colors.green.withValues(alpha: 0.15);
          borderColor = Colors.green.withValues(alpha: 0.3);
          iconColor = Colors.green.shade800;
          iconData = Icons.verified_user_rounded;
          titleColor = Colors.green.shade900;
          break;
        case RiskLevel.medium:
          bgColor = Colors.orange.withValues(alpha: 0.15);
          borderColor = Colors.orange.withValues(alpha: 0.3);
          iconColor = Colors.orange.shade800;
          iconData = Icons.warning_amber_rounded;
          titleColor = Colors.orange.shade900;
          break;
        case RiskLevel.severe:
          bgColor = AppColors.coral.withValues(alpha: 0.15);
          borderColor = AppColors.coral.withValues(alpha: 0.3);
          iconColor = const Color(0xFFE65100);
          iconData = Icons.dangerous_rounded;
          titleColor = const Color(0xFFBF360C);
          break;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: titleColor.withValues(alpha: 0.8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (riskState.error != null)
            IconButton(
              onPressed: () =>
                  ref.read(locationRiskProvider.notifier).fetchRiskData(),
              icon: const Icon(Icons.refresh),
              color: iconColor,
              iconSize: 20,
            )
          else
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: titleColor.withValues(alpha: 0.5),
              size: 16,
            ),
        ],
      ),
    );
  }

  // ── Modules Grid ──────────────────────────────────────────────────
  Widget _buildModulesGrid(BuildContext context, ThemeData theme) {
    final modules = [
      {
        'title': 'Earthquake',
        'subtitle': 'Safety & Drills',
        'icon': Icons.landscape_rounded,
        'color': AppColors.mint,
        'iconColor': AppColors.mintDark,
      },
      {
        'title': 'Flood',
        'subtitle': 'Rescue & Alerts',
        'icon': Icons.waves_rounded,
        'color': AppColors.skyBlue,
        'iconColor': AppColors.skyBlueDark,
      },
      {
        'title': 'Fire',
        'subtitle': 'Response Plans',
        'icon': Icons.whatshot_rounded,
        'color': AppColors.coral,
        'iconColor': AppColors.coralDark,
      },
      {
        'title': 'Cyclone',
        'subtitle': 'Weather Updates',
        'icon': Icons.cyclone_rounded,
        'color': AppColors.lilac,
        'iconColor': AppColors.lilacDark,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        // Staggered entrance animation
        final delay = index * 0.15;
        final animation = CurvedAnimation(
          parent: _staggerController,
          curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: _buildModuleCard(context, theme, module),
          ),
        );
      },
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> module,
  ) {
    return Material(
      color: (module['color'] as Color).withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          if (module['title'] == 'Flood') {
            context.push('/simulation');
          }
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large centered icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (module['color'] as Color).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  module['icon'] as IconData,
                  size: 34,
                  color: module['iconColor'] as Color,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                module['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: module['iconColor'] as Color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                module['subtitle'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: (module['iconColor'] as Color).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Navigation with SOS ──────────────────────────────────────
  Widget _buildBottomNav(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _navItem(Icons.home_rounded, 'Home', 0)),
              Expanded(child: _navItem(Icons.menu_book_rounded, 'Learn', 1)),
              _buildSOSButton(),
              Expanded(
                child: _navItem(Icons.notifications_outlined, 'Alerts', 2),
              ),
              Expanded(
                child: _navItem(Icons.person_outline_rounded, 'Profile', 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── SOS Button ────────────────────────────────────────────────────
  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: () {
        _showSOSDialog();
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFFF6B35)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emergency_rounded, color: Colors.white, size: 22),
            Text(
              'SOS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callNumber(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showSOSDialog() {
    final emergencyNumbers = [
      {
        'name': 'Emergency (All)',
        'number': '112',
        'icon': Icons.emergency_rounded,
        'color': const Color(0xFFEF4444),
      },
      {
        'name': 'Police',
        'number': '100',
        'icon': Icons.local_police_rounded,
        'color': const Color(0xFF1565C0),
      },
      {
        'name': 'Fire Brigade',
        'number': '101',
        'icon': Icons.fire_truck_rounded,
        'color': const Color(0xFFE65100),
      },
      {
        'name': 'Ambulance',
        'number': '108',
        'icon': Icons.local_hospital_rounded,
        'color': const Color(0xFF2E7D32),
      },
      {
        'name': 'Disaster Mgmt (NDMA)',
        'number': '1078',
        'icon': Icons.warning_amber_rounded,
        'color': const Color(0xFFF57F17),
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.emergency_rounded,
                        color: Color(0xFFEF4444),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency SOS',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tap to call emergency services',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Emergency numbers list
                ...emergencyNumbers.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: (item['color'] as Color).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _callNumber(item['number'] as String);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      item['number'] as String,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: item['color'] as Color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.call_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.outline;

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
