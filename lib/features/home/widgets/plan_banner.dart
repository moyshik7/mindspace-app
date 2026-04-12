import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../data/models/user_model.dart';

class PlanBanner extends StatelessWidget {
  final PlanType planType;
  final VoidCallback? onUpgrade;

  const PlanBanner({
    super.key,
    required this.planType,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: switch (planType) {
        PlanType.free => _buildFreeBanner(),
        PlanType.pro => _buildProBanner(),
        PlanType.ultra => _buildUltraBanner(),
      },
    );
  }

  Widget _buildFreeBanner() {
    return AppCard(
      gradient: LinearGradient(
        colors: [
          AppColors.primaryDeeper.withValues(alpha: 0.12),
          AppColors.accent.withValues(alpha: 0.06),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Unlock Your Full Potential 🚀',
                style: AppTypography.headingM.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _benefitRow('✦', 'Unlimited Mehrin AI chat'),
          const SizedBox(height: 6),
          _benefitRow('✦', 'Full course library'),
          const SizedBox(height: 6),
          _benefitRow('✦', 'Priority support'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Try Pro — 299 BDT/mo',
                  onTap: onUpgrade,
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: onUpgrade,
                child: Text(
                  'See Ultra',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProBanner() {
    return AppCard(
      gradient: LinearGradient(
        colors: [
          AppColors.primaryDeeper.withValues(alpha: 0.1),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You\'re on Pro ⭐',
            style: AppTypography.headingM.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          _checkRow('Unlimited Mehrin AI chat'),
          const SizedBox(height: 4),
          _checkRow('Full course library'),
          const SizedBox(height: 4),
          _checkRow('Priority support'),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onUpgrade,
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              'Upgrade to Ultra →',
              style: AppTypography.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraBanner() {
    return AppCard(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFffd700).withValues(alpha: 0.08),
          Colors.transparent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: const Color(0xFFffd700).withValues(alpha: 0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ultra Member 💎',
            style: AppTypography.headingM.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          _checkRow('All Pro features included'),
          const SizedBox(height: 4),
          _checkRow('Early access to new features'),
          const SizedBox(height: 4),
          _checkRow('Exclusive community badge'),
        ],
      ),
    );
  }

  Widget _benefitRow(String icon, String text) {
    return Row(
      children: [
        Text(icon,
            style: const TextStyle(color: AppColors.primary, fontSize: 12)),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _checkRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded,
            color: AppColors.success, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
