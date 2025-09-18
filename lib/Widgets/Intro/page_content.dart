import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageContent extends StatefulWidget {
  final int index;
  final Function(String?) onLanguageSelected;
  final String? selectedLanguage;
  final bool showOnlyVisual;
  final bool showOnlyText;

  const PageContent({
    Key? key,
    required this.index,
    required this.onLanguageSelected,
    this.selectedLanguage,
    this.showOnlyVisual = false,
    this.showOnlyText = false,
  }) : super(key: key);

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  String? _selectedLanguage;
  final Map<String, String> _languages = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
  };

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  void didUpdateWidget(covariant PageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLanguage != widget.selectedLanguage) {
      setState(() {
        _selectedLanguage = widget.selectedLanguage;
      });
    }
  }

  Future<Map<String, dynamic>> _getLocalizedContent() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        widget.selectedLanguage ?? prefs.getString('language') ?? 'en';

    Map<int, Map<String, dynamic>> content = {
      0: {
        'type': 'language',
        'icon': FontAwesomeIcons.language.codePoint.toString(),
        'title': 'Select Language',
        'description': 'Choose your preferred language for the app',
      },
      1: {
        'type': 'image',
        'asset': 'images/hirfalogo.png',
        'title': 'Welcome to Hirfa!',
        'description':
            'Discover skilled artisans and trusted services near you—find, book, and connect with professionals for every need.',
      },
      2: {
        'type': 'icon',
        'icon': FontAwesomeIcons.users.codePoint.toString(),
        'title': 'Choose Your Role',
        'description': 'Select how you want to use our platform',
      },
    };

    if (languageCode == 'fr') {
      content = {
        0: {
          'type': 'language',
          'icon': FontAwesomeIcons.language.codePoint.toString(),
          'title': 'Choisir la langue',
          'description': 'Choisissez votre langue préférée pour l\'application',
        },
        1: {
          'type': 'image',
          'asset': 'images/hirfalogo.png',
          'title': 'Bienvenue à Hirfa!',
          'description':
              'Découvrez des artisans qualifiés et des services de confiance près de chez vous : trouvez, réservez et contactez des professionnels pour tous vos besoins.',
        },
        2: {
          'type': 'icon',
          'icon': FontAwesomeIcons.users.codePoint.toString(),
          'title': 'Choisissez Votre Rôle',
          'description':
              'Sélectionnez comment vous souhaitez utiliser notre plateforme',
        },
      };
    } else if (languageCode == 'ar') {
      content = {
        0: {
          'type': 'language',
          'icon': FontAwesomeIcons.language.codePoint.toString(),
          'title': 'اختر اللغة',
          'description': 'اختر اللغة المفضلة للتطبيق',
        },
        1: {
          'type': 'image',
          'asset': 'images/hirfalogo.png',
          'title': 'مرحبًا بك في هرفا!',
          'description':
              'اكتشف الحرفيين المهرة والخدمات الموثوقة بالقرب منك — ابحث عن محترفين لكل احتياج، واحجزهم، وتواصل معهم',
        },
        2: {
          'type': 'icon',
          'icon': FontAwesomeIcons.users.codePoint.toString(),
          'title': 'اختر دورك',
          'description': 'حدد كيف تريد استخدام منصتنا',
        },
      };
    }

    return content[widget.index] ?? content[0]!;
  }

  Widget _buildVisualContent(Map<String, dynamic> content) {
    switch (content['type']) {
      case 'language':
        return FaIcon(
          IconData(
            int.parse(content['icon']!),
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          ),
          size: 100,
          color: Colors.black,
        );
      case 'image':
        return Image.asset(
          content['asset']!,
          height: 200,
          width: 200,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.image,
                size: 60,
                color: Color(0xFF863a3a),
              ),
            );
          },
        );
      case 'icon':
        return FaIcon(
          IconData(
            int.parse(content['icon']!),
            fontFamily: 'FontAwesomeSolid',
            fontPackage: 'font_awesome_flutter',
          ),
          size: 100,
          color: Colors.black,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getLocalizedContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = snapshot.data!;

        // Show only visual element (image/icon)
        if (widget.showOnlyVisual) {
          return Center(child: _buildVisualContent(content));
        }

        // Show only text content
        if (widget.showOnlyText) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content['title']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  content['description']!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Language dropdown (only for first page)
              if (widget.index == 0 && content['type'] == 'language') ...[
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E8E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFFF0E8E2),
                    value: _selectedLanguage,
                    hint: const Text(
                      'Choose language',
                      style: TextStyle(color: Color(0xC15C4B4B)),
                    ),
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xC15C4B4B),
                      size: 28,
                    ),
                    iconSize: 28,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1a1a1a),
                    ),
                    items:
                        _languages.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1a1a1a),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                      widget.onLanguageSelected(value);
                    },
                  ),
                ),
              ],
            ],
          );
        }

        // Default: Show both visual and text (for backward compatibility)
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildVisualContent(content),
            const SizedBox(height: 40),
            Text(
              content['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                content['description']!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (widget.index == 0 && content['type'] == 'language') ...[
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFFF0E8E2),
                  value: _selectedLanguage,
                  hint: const Text(
                    'Choose language',
                    style: TextStyle(color: Color(0xC15C4B4B)),
                  ),
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xC15C4B4B),
                    size: 28,
                  ),
                  iconSize: 28,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1a1a1a),
                  ),
                  items:
                      _languages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1a1a1a),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    widget.onLanguageSelected(value);
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
