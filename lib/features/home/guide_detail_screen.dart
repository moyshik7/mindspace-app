import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/dummy_data.dart';

class GuideDetailScreen extends StatelessWidget {
  final String guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    final guide = DummyData.guides.firstWhere(
      (g) => g.id == guideId,
      orElse: () => DummyData.guides.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          guide.title,
          style: AppTypography.headingM.copyWith(fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      guide.gradientColors[0].withValues(alpha: 0.2),
                      guide.gradientColors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: guide.gradientColors[0].withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(guide.emoji,
                      style: const TextStyle(fontSize: 48)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Read time badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(guide.readTime, style: AppTypography.caption),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Content
            _buildContent(guide.content),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String content) {
    final lines = content.trim().split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else if (trimmed.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            trimmed.substring(2),
            style: AppTypography.headingL,
          ),
        ));
      } else if (trimmed.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            trimmed.substring(3),
            style: AppTypography.headingM,
          ),
        ));
      } else if (trimmed.startsWith('• ') || trimmed.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: AppTypography.body.copyWith(
                  color: AppColors.primary)),
              Expanded(
                child: Text(
                  trimmed.substring(2),
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ));
      } else if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            trimmed.replaceAll('**', ''),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primaryLight,
            ),
          ),
        ));
      } else {
        widgets.add(Text(
          trimmed,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
