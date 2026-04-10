import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models/user_model.dart';
import '../../providers/providers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onTap: planType == PlanType.free ? () {
                ref.read(userProvider.notifier).updatePlan(planType);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Switched to FREE plan (demo)'),
                  ),
                );
              } : () => _showPaymentSheet(context, title, price),
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

  void _showPaymentSheet(BuildContext context, String planTitle, String price) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Complete your payment',
                style: AppTypography.headingM,
              ),
              const SizedBox(height: 8),
              Text(
                'For $planTitle ($price)',
                style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              // Google Pay
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.payment),
                label: const Text('Pay with Google Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              // Apple Pay
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
                icon: const Icon(Icons.apple),
                label: const Text('Pay with Apple Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.surfaceBorder),
              const SizedBox(height: 16),
              // Pay Manually
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final message = '[Subscribe] Mindspace: $planTitle Plan [$price]';
                  final url = Uri.parse('https://wa.me/+8801805527311?text=${Uri.encodeComponent(message)}');
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    debugPrint('Could not launch WhatsApp: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Pay Manually', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              // bKash & Nagad Logos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo/bkash.svg',
                    height: 30,
                    errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet, color: Colors.pink, size: 30),
                  ),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/images/logo/nagad.png',
                    height: 30,
                    errorBuilder: (c, e, s) => const Icon(Icons.payments, color: Colors.orange, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _Feature {
  final String text;
  final bool included;

  const _Feature(this.text, this.included);
}
