import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LearnDetailScreen extends StatefulWidget {
  final Map<String, dynamic> moduleData;

  const LearnDetailScreen({super.key, required this.moduleData});

  @override
  State<LearnDetailScreen> createState() => _LearnDetailScreenState();
}

class _LearnDetailScreenState extends State<LearnDetailScreen> {
  late YoutubePlayerController _ytController;

  static const _moduleContent = {
    'earthquake': {
      'videoId':
          'https://youtu.be/S6BFw4ZURZQ?si=gpdwaJIm8rO38hGX', // Example: "Earthquake Safety Video"
      'content': '''
**Before an Earthquake**
• Secure heavy items in your home like bookcases, refrigerators, and water heaters.
• Create a family emergency communication plan.
• Prepare a disaster supply kit with food, water, flashlights, and a first aid kit.

**During an Earthquake**
• **DROP, COVER, and HOLD ON**. Drop to your hands and knees. Cover your head and neck with your arms. Hold on to any sturdy furniture until the shaking stops.
• If you are indoors, stay there. Do not run outside.
• If you are outdoors, stay away from buildings, streetlights, and utility wires.
• If you are driving, pull over to a clear location and stop.

**After an Earthquake**
• Expect aftershocks.
• Check yourself for injuries and get first aid if necessary.
• If you are in a damaged building, go outside and quickly move away from it.
• Do not enter damaged buildings.
      ''',
    },
    'flood': {
      'videoId': 'https://youtu.be/pi_nUPcQz_A?si=Qzm0XxIt7U3n9es6',
      'content': '''
**Before a Flood**
• Know your area's flood risk.
• Pack an emergency kit and have a family communication plan.
• Elevate the furnace, water heater, and electric panel if susceptible to flooding.

**During a Flood**
• Do not walk, swim, or drive through floodwaters. **Turn Around, Don't Drown!**
• Just six inches of moving water can knock you down, and one foot of moving water can sweep your vehicle away.
• Stay off bridges over fast-moving water.

**After a Flood**
• Return home only when authorities say it is safe.
• Avoid driving except in emergencies.
• Wear heavy work gloves, protective clothing, and boots during clean-up to avoid injury/infection.
      ''',
    },
    'fire': {
      'videoId':
          'https://youtu.be/Xgc90CoJbDI?si=Jg73A01WzN7NVTPw', // Example: "Fire Escape Plan"
      'content': '''
**Before a Fire**
• Install smoke alarms on every level of your home. Test them monthly.
• Create and practice a home fire escape plan mapping two ways out of every room.
• Keep flammable items away from anything that can get hot (space heaters, stoves).

**During a Fire**
• **Get out, stay out, and call for help.** Never go back inside for anything or anyone.
• Yell "Fire!" to alert others.
• If smoke is present, get low and crawl under it. The air is cleaner near the floor.
• If your clothes catch fire: **STOP, DROP, and ROLL**.

**After a Fire**
• Contact your local disaster relief service, such as the Red Cross.
• Do not reconnect utilities yourself. Let the fire department or utility companies handle it.
      ''',
    },
    'cyclone': {
      'videoId':
          'https://youtu.be/xHRbnuB9F1I?si=tAkv_L_OF8SDG8LL', // Example: "Cyclone Preparedness"
      'content': '''
**Before a Cyclone**
• Check your house roof and repair any loose tiles or iron sheets.
• Trim branches of trees near your house.
• Keep your emergency kit ready with a radio, torch, batteries, and essential documents in waterproof bags.
• Tape glass windows to prevent them from shattering.

**During a Cyclone**
• Stay indoors in the strongest part of your house (usually a bathroom or hallway).
• Stay away from windows and glass doors.
• Turn off main gas and electricity if instructed by authorities.
• Do not go outside if the wind suddenly drops; it could be the eye of the storm (the calm center).

**After a Cyclone**
• Don't go outside until officially advised it is safe.
• Check for gas leaks. Don't use matches or lighters.
• Stay away from fallen power lines, damaged bridges, and flooded areas.
      ''',
    },
  };

  @override
  void initState() {
    super.initState();
    final id = widget.moduleData['id'] as String;
    String videoId = _moduleContent[id]!['videoId']!;

    // Extract video ID if it's a full URL
    if (videoId.contains('youtube.com') || videoId.contains('youtu.be')) {
      final uri = Uri.tryParse(videoId);
      if (uri != null) {
        if (uri.host.contains('youtu.be')) {
          videoId = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.first
              : videoId;
        } else if (uri.host.contains('youtube.com')) {
          videoId = uri.queryParameters['v'] ?? videoId;
        }
      }
    }

    _ytController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(widget.moduleData['color'] as int);
    final bgColor = Color(widget.moduleData['bgColor'] as int);
    final id = widget.moduleData['id'] as String;
    final content = _moduleContent[id]!['content']!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.moduleData['title'] as String,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Header Card
            Hero(
              tag: 'module_\$id',
              child: Material(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          IconData(
                            widget.moduleData['icon'] as int,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: color,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Survival Guide',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: color.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.moduleData['subtitle'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: color,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 2. Video Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.play_circle_fill_rounded, color: color),
                      const SizedBox(width: 8),
                      Text(
                        'Watch & Learn',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Builder(
                      builder: (context) {
                        return YoutubePlayer(
                          controller: _ytController,
                          aspectRatio: 16 / 9,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. Reading Material Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: color),
                      const SizedBox(width: 8),
                      Text(
                        'Step-by-Step Guide',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormattedContent(content, theme, color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedContent(
    String text,
    ThemeData theme,
    Color primaryColor,
  ) {
    final lines = text.trim().split('\\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      if (line.startsWith('**') && line.endsWith('**')) {
        // Heading
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              line.replaceAll('**', ''),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
        );
      } else if (line.startsWith('•')) {
        // Bullet point
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 12),
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: primaryColor.withValues(alpha: 0.5),
                  ),
                ),
                Expanded(
                  child: _RichTextParser(
                    text: line.substring(1).trim(),
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Normal paragraph
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RichTextParser(text: line, theme: theme),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

// Helper to parse **bold** text within paragraphs/bullets
class _RichTextParser extends StatelessWidget {
  final String text;
  final ThemeData theme;

  const _RichTextParser({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final parts = text.split('**');

    for (var i = 0; i < parts.length; i++) {
      final isBold = i % 2 != 0;
      spans.add(
        TextSpan(
          text: parts[i],
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
