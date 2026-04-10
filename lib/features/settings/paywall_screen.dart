import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models/user_model.dart';
import '../../providers/providers.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Choose Your Plan',
          style: AppTypography.headingM.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Invest in your mental health',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Plan cards
            _buildPlanCard(
              context,
              ref,
              title: 'Free',
              price: '\$0',
              period: '/forever',
              features: [
                _Feature('3 course lessons', true),
                _Feature('Community access', true),
                _Feature('Daily tips', true),
                _Feature('Unlimited AI chat', false),
                _Feature('Full course library', false),
                _Feature('Priority support', false),
              ],
              isCurrentPlan: user.planType == PlanType.free,
              planType: PlanType.free,
              accentColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),

            _buildPlanCard(
              context,
              ref,
              title: 'Pro ⭐',
              price: '\$4.99',
              period: '/month',
              features: [
                _Feature('Unlimited course access', true),
                _Feature('Full community features', true),
                _Feature('Daily tips & guides', true),
                _Feature('AI chat (100 msgs/day)', true),
                _Feature('Priority support', true),
                _Feature('Early access features', false),
              ],
              isCurrentPlan: user.planType == PlanType.pro,
              planType: PlanType.pro,
              accentColor: AppColors.primary,
              isPopular: true,
            ),
            const SizedBox(height: 14),

            _buildPlanCard(
              context,
              ref,
              title: 'Ultra 💎',
              price: '\$9.99',
              period: '/month',
              features: [
                _Feature('Everything in Pro', true),
                _Feature('Unlimited AI chat', true),
                _Feature('Exclusive community badge', true),
                _Feature('Early access to features', true),
                _Feature('1-on-1 support sessions', true),
                _Feature('Custom wellness plans', true),
              ],
              isCurrentPlan: user.planType == PlanType.ultra,
              planType: PlanType.ultra,
              accentColor: const Color(0xFFffd700),
            ),

            const SizedBox(height: 24),
            Text(
              'Subscriptions can be cancelled anytime.\nNo payment processing yet — plan selection for demo only.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String price,
    required String period,
    required List<_Feature> features,
    required bool isCurrentPlan,
    required PlanType planType,
    required Color accentColor,
    bool isPopular = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPopular
              ? AppColors.primary.withValues(alpha: 0.5)
              : isCurrentPlan
                  ? accentColor.withValues(alpha: 0.3)
                  : AppColors.surfaceBorder,
          width: isPopular || isCurrentPlan ? 1.5 : 1,
        ),
        boxShadow: isPopular ? AppColors.primaryGlow : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: AppTypography.headingM),
              const Spacer(),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'POPULAR',
                    style: AppTypography.label.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'CURRENT',
                    style: AppTypography.label.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: AppTypography.headingXL.copyWith(
                  fontSize: 32,
                  color: accentColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 2),
                child: Text(
                  period,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      f.included
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 16,
                      color: f.included
                          ? AppColors.success
                          : AppColors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f.text,
                      style: AppTypography.body.copyWith(
                        color: f.included
                            ? AppColors.textSecondary
                            : AppColors.textMuted.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          if (!isCurrentPlan)
            GradientButton(
              text: 'Select $title',
              colors: planType == PlanType.free
                  ? [AppColors.surfaceElevated, AppColors.surfaceElevated]
                  : null,
              onTap: () {
                ref.read(userProvider.notifier).updatePlan(planType);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Switched to ${planType.name.toUpperCase()} plan (demo)'),
                  ),
                );
              },
            )
          else
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Current Plan',
                  style: AppTypography.button.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Feature {
  final String text;
  final bool included;

  const _Feature(this.text, this.included);
}
