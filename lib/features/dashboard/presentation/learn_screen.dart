import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static const _modules = [
    {
      'id': 'earthquake',
      'title': 'Earthquake Safety',
      'subtitle': 'Learn how to Drop, Cover, and Hold On.',
      'color': 0xFF2D6A4F,
      'bgColor': 0xFFE8F5E9,
      'icon': 0xe3ab, // Icons.landscape_rounded
    },
    {
      'id': 'flood',
      'title': 'Flood Survival',
      'subtitle': 'Navigate high waters and find safe ground.',
      'color': 0xFF1565C0,
      'bgColor': 0xFFE3F2FD,
      'icon': 0xf07db, // Icons.waves_rounded
    },
    {
      'id': 'fire',
      'title': 'Fire Evacuation',
      'subtitle': 'Escape routes, smoke safety, and extinguishers.',
      'color': 0xFFC62828,
      'bgColor': 0xFFFFEBEE,
      'icon': 0xe28d, // Icons.whatshot_rounded
    },
    {
      'id': 'cyclone',
      'title': 'Cyclone Preparedness',
      'subtitle': 'Secure your home and build an emergency kit.',
      'color': 0xFF6A1B9A,
      'bgColor': 0xFFF3E5F5,
      'icon': 0xe1a9, // Icons.cyclone_rounded
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learning Modules',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];
          return _buildModuleCard(context, theme, module);
        },
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> module,
  ) {
    final color = Color(module['color'] as int);
    final bgColor = Color(module['bgColor'] as int);
    final id = module['id'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Hero(
        tag: 'module_$id',
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => context.push('/learn/$id', extra: module),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          IconData(
                            module['icon'] as int,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: color,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: color.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    module['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    module['subtitle'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        'Read & Watch',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
