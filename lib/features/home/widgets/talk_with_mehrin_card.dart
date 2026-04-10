import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

class TalkWithMehrinCard extends StatelessWidget {
  const TalkWithMehrinCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.flairAnxiety, size: 20),
              const SizedBox(width: 8),
              Text(
                'Talk with Mehrin',
                style: AppTypography.headingSmall.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => context.push('/mehrin'),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE5D5FF), // Purple theme suitable for Mehrin
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white30,
                    child: Icon(Icons.face, color: Color(0xFF5A189A), size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need to talk?',
                          style: AppTypography.headingMedium.copyWith(color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Mehrin's listening",
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.black54, 
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text('Start Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
