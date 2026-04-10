import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/gradient_button.dart';

class ReportSheet extends StatelessWidget {
  const ReportSheet({super.key});

  static const _reasons = [
    "It's spam",
    'Harmful or dangerous content',
    'Misinformation',
    'Harassment',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text('Report Post', style: AppTypography.headingM),
          const SizedBox(height: 4),
          Text(
            'Why are you reporting this post?',
            style:
                AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          ...List.generate(_reasons.length, (index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Thank you for your report. We\'ll review this post.'),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Text(
                  _reasons[index],
                  style: AppTypography.body,
                ),
              ),
            );
          }),

          const SizedBox(height: 8),
          GradientButton(
            text: 'Cancel',
            colors: [AppColors.surface, AppColors.surface],
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
