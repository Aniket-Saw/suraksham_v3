import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:timeago/timeago.dart' as timeago;

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _newsArticles = [];

  @override
  void initState() {
    super.initState();
    _fetchLiveNews();
  }

  Future<void> _fetchLiveNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch Google News RSS for disaster-related news in India
      final query = Uri.encodeComponent(
        'India (disaster OR flood OR earthquake OR cyclone OR hazard)',
      );
      final rawUrl =
          'https://news.google.com/rss/search?q=$query&hl=en-IN&gl=IN&ceid=IN:en';
      // Use corsproxy.io to bypass Flutter Web CORS restrictions
      final url = Uri.parse(
        'https://corsproxy.io/?${Uri.encodeComponent(rawUrl)}',
      );

      final response = await http
          .get(
            url,
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
              'Accept': 'application/rss+xml, application/xml, text/xml',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the RSS feed
        final utf8Bytes = response.bodyBytes;
        final decodedBody = utf8.decode(utf8Bytes, allowMalformed: true);
        final feed = RssFeed.parse(decodedBody);

        final articles = feed.items.take(15).map((item) {
          // Google News formats titles like: "Actual Title - Source Name"
          final fullTitle = item.title ?? 'No title';
          final parts = fullTitle.split(' - ');
          final source = parts.length > 1 ? parts.last : 'News Source';
          final title = parts.length > 1
              ? parts.sublist(0, parts.length - 1).join(' - ')
              : fullTitle;

          // Parse pubDate
          final pubDate = item.pubDate;
          String timeString = 'Just now';
          if (pubDate != null) {
            try {
              // RFC 822 format manually parsed or parsed via DateTime if standard
              // Using a simple fallback for robust parsing
              final date = _parseRssDate(pubDate);
              timeString = timeago.format(date);
            } catch (e) {
              timeString = 'Recently';
            }
          }

          // Category logic based on keywords
          final lowercaseTitle = title.toLowerCase();
          String category = 'Alert';
          int iconCode = Icons.warning_amber_rounded.codePoint;
          int colorHex = 0xFFF57F17;
          int bgColorHex = 0xFFFFF8E1;

          if (lowercaseTitle.contains('flood') ||
              lowercaseTitle.contains('rain')) {
            category = 'Flood';
            iconCode = Icons.waves_rounded.codePoint;
            colorHex = 0xFF1565C0;
            bgColorHex = 0xFFE3F2FD;
          } else if (lowercaseTitle.contains('earthquake') ||
              lowercaseTitle.contains('quake')) {
            category = 'Earthquake';
            iconCode = Icons.landscape_rounded.codePoint;
            colorHex = 0xFF2D6A4F;
            bgColorHex = 0xFFE8F5E9;
          } else if (lowercaseTitle.contains('cyclone') ||
              lowercaseTitle.contains('storm')) {
            category = 'Cyclone';
            iconCode = Icons.cyclone_rounded.codePoint;
            colorHex = 0xFF6A1B9A;
            bgColorHex = 0xFFF3E5F5;
          } else if (lowercaseTitle.contains('fire')) {
            category = 'Fire';
            iconCode = Icons.whatshot_rounded.codePoint;
            colorHex = 0xFFC62828;
            bgColorHex = 0xFFFFEBEE;
          } else if (lowercaseTitle.contains('landslide')) {
            category = 'Landslide';
            iconCode = Icons.terrain_rounded.codePoint;
            colorHex = 0xFF4E342E;
            bgColorHex = 0xFFEFEBE9;
          }

          return {
            'title': title,
            'source': source,
            'time': timeString,
            'category': category,
            'color': colorHex,
            'bgColor': bgColorHex,
            'icon': iconCode,
            'url': item.link ?? '',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _newsArticles = articles;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Unable to fetch real-time alerts. Please check your connection.';
          _isLoading = false;
        });
      }
    }
  }

  DateTime _parseRssDate(String dateString) {
    try {
      // Dart's HttpDate handles standard RFC 1123 format commonly used in RSS
      return HttpDate.parse(dateString);
    } catch (_) {
      try {
        // Fallback for loosely formatted dates
        return DateTime.parse(dateString);
      } catch (_) {
        return DateTime.now();
      }
    }
  }

  Future<void> _openArticle(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Live Disaster Alerts',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _fetchLiveNews,
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Fetching live updates...',
              style: GoogleFonts.plusJakartaSans(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Connection Error',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: theme.colorScheme.outline,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _fetchLiveNews,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_newsArticles.isEmpty) {
      return Center(
        child: Text(
          'No recent alerts found.',
          style: GoogleFonts.plusJakartaSans(color: theme.colorScheme.outline),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchLiveNews,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _newsArticles.length,
        itemBuilder: (context, index) {
          final article = _newsArticles[index];
          return _buildNewsCard(context, theme, article);
        },
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> article,
  ) {
    final color = Color(article['color'] as int);
    final bgColor = Color(article['bgColor'] as int);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        child: InkWell(
          onTap: () => _openArticle(article['url'] as String),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    IconData(
                      article['icon'] as int,
                      fontFamily: 'MaterialIcons',
                    ),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article['category'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        article['title'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Source & time
                      Row(
                        children: [
                          Text(
                            article['source'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          Text(
                            article['time'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 14,
                            color: theme.colorScheme.outline,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
