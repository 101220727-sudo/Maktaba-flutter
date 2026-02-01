import 'package:flutter/material.dart';
import '../models/user.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF76499C).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Color(0xFF4ABC9D),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'أهلاً، ${user.name}!',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF76499C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.email_outlined, user.email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, user.phoneNumber),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on_outlined, user.location),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF4ABC9D), size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
        ),
      ],
    );
  }
}
