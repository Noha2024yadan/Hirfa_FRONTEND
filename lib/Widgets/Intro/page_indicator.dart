import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int current;
  const PageIndicator({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = current == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF863a3a) : const Color(0xFFF0E8E2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
