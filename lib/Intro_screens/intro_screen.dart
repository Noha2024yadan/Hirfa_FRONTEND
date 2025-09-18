import 'package:flutter/material.dart';
import 'package:hirfa_frontend/Widgets/Intro/page_content.dart';
import 'package:hirfa_frontend/Widgets/Intro/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _visualPageController = PageController(initialPage: 0);
  final PageController _textPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  static const int _pageCount = 3;
  String? _selectedLanguage;
  bool _isLanguageSelected = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage;
        _isLanguageSelected = true;
      });
    }
  }

  @override
  void dispose() {
    _visualPageController.dispose();
    _textPageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    // Don't allow navigation back to page 0 if language is already selected
    if (page == 0 && _isLanguageSelected) {
      return;
    }

    // Only allow navigation if we're going to page 0 or if language is selected
    if (page == 0 || _isLanguageSelected) {
      setState(() {
        _currentPage = page;
      });
      _visualPageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _textPageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top section for visual content (image/icon) - 30%
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: _buildVisualSection(),
            ),

            // Middle section for text content - 40%
            Expanded(child: _buildTextSection()),

            // Bottom section for indicators and buttons - 30%
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: _buildBottomSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualSection() {
    return PageView.builder(
      controller: _visualPageController,
      physics:
          const NeverScrollableScrollPhysics(), // Always disabled for visual
      itemCount: _pageCount,
      itemBuilder: (context, index) {
        return Center(
          child: PageContent(
            index: index,
            selectedLanguage: _selectedLanguage,
            onLanguageSelected: (language) {
              setState(() {
                _selectedLanguage = language;
                _isLanguageSelected = language != null;
              });
            },
            showOnlyVisual: true,
          ),
        );
      },
    );
  }

  Widget _buildTextSection() {
    return PageView(
      controller: _textPageController,
      onPageChanged: (int page) {
        // Prevent going back to language page (page 0) if language is already selected
        if (page == 0 && _isLanguageSelected) {
          Future.microtask(() {
            _textPageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
          return;
        }

        // Only allow page changes if we're on page 0 or language is selected
        if (page == 0 || _isLanguageSelected) {
          setState(() {
            _currentPage = page;
          });
          // Sync the visual page controller
          _visualPageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          // Go back to current page if language not selected
          Future.microtask(() {
            _textPageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        }
      },
      // Dynamic physics based on page and language selection
      physics: _getPagePhysics(),
      children: List.generate(_pageCount, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: PageContent(
            index: i,
            selectedLanguage: _selectedLanguage,
            onLanguageSelected: (language) {
              setState(() {
                _selectedLanguage = language;
                _isLanguageSelected = language != null;
              });
            },
            showOnlyText: true,
          ),
        );
      }),
    );
  }

  ScrollPhysics _getPagePhysics() {
    if (_currentPage == 0) {
      // On language page - completely disable swiping, force button usage
      return const NeverScrollableScrollPhysics();
    } else if (_isLanguageSelected) {
      // After language selection on other pages - allow normal swiping only between pages 1 and 2
      return const AlwaysScrollableScrollPhysics();
    } else {
      // Default: no swiping if language not selected
      return const NeverScrollableScrollPhysics();
    }
  }

  Widget _buildBottomSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PageIndicator(current: _currentPage),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment:
                _currentPage == _pageCount - 1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage < _pageCount - 1) _buildSkipButton(),
              _buildNextButton(),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSkipButton() {
    final isDisabled = _currentPage == 0 && !_isLanguageSelected;

    return TextButton(
      onPressed:
          isDisabled
              ? null
              : () {
                _navigateToPage(_pageCount - 1);
              },
      child: Text(
        _getSkipText(),
        style: TextStyle(
          color: isDisabled ? const Color(0xC15C4B4B) : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isDisabled = _currentPage == 0 && !_isLanguageSelected;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFF0E8E2);
          }
          return const Color(0xFF863a3a);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xC15C4B4B);
          }
          return Colors.white;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.pressed)) {
            return const Color(0xFF6C2A2A).withOpacity(0.2);
          }
          return Colors.transparent;
        }),
        minimumSize: WidgetStateProperty.all(const Size(120, 35)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      onPressed:
          isDisabled
              ? null
              : () async {
                if (_currentPage < _pageCount - 1) {
                  _navigateToPage(_currentPage + 1);
                } else {
                  // Save language and navigate to role selection
                  if (_selectedLanguage != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('language', _selectedLanguage!);
                  }

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('intro_seen', true);
                  if (mounted) Navigator.pushReplacementNamed(context, '/role');
                }
              },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_getNextButtonText()),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            color: isDisabled ? const Color(0xC15C4B4B) : Colors.white,
            size: 22,
          ),
        ],
      ),
    );
  }

  String _getSkipText() {
    if (_selectedLanguage == 'fr') {
      return 'PASSER';
    } else if (_selectedLanguage == 'ar') {
      return 'تخطي';
    }
    return 'SKIP';
  }

  String _getNextButtonText() {
    if (_currentPage == _pageCount - 1) {
      if (_selectedLanguage == 'fr') {
        return 'CONTINUER';
      } else if (_selectedLanguage == 'ar') {
        return 'متابعة';
      }
      return 'CONTINUE';
    } else {
      if (_selectedLanguage == 'fr') {
        return 'SUIVANT';
      } else if (_selectedLanguage == 'ar') {
        return 'التالي';
      }
      return 'NEXT';
    }
  }
}
