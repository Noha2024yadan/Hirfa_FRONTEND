import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: OutlinedButton(
            onPressed: () {
              // Logout functionality
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              side: const BorderSide(color: Color(0xFF863a3a)),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFF863a3a)),
            ),
          ),
        ),
      ],
    );
  }
}
