import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/article_providers.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final String slug;

  const ArticleDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(slug));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: articleAsync.when(
        data: (article) {
          if (article == null) return const Center(child: Text('Article not found'));
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: article.image,
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: AppTypography.headingL,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(article.readingTime, style: AppTypography.caption),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(article.date, style: AppTypography.caption),
                        ],
                      ),
                      const SizedBox(height: 24),
                      MarkdownBody(
                        data: article.content ?? article.description,
                        styleSheet: MarkdownStyleSheet(
                          p: AppTypography.body.copyWith(height: 1.6, color: AppColors.textPrimary.withValues(alpha: 0.9)),
                          h1: AppTypography.headingL,
                          h2: AppTypography.headingM,
                          h3: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          strong: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          listBullet: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: article.keywords.map((kw) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.surfaceBorder),
                          ),
                          child: Text(
                            '#$kw',
                            style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.primary),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error loading article')),
      ),
    );
  }
}
