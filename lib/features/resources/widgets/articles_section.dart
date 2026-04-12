import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/staggered_fade_slide.dart';
import '../../../providers/article_providers.dart';
import 'article_card.dart';

class ArticlesSection extends ConsumerWidget {
  const ArticlesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Psychology Articles', style: AppTypography.headingM),
              TextButton(
                onPressed: () => context.push('/articles'),
                child: Text(
                  'View All',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 380, // Adjust height as needed
          child: articlesAsync.when(
            data: (articles) {
              if (articles.isEmpty) return const SizedBox.shrink();
              
              final previewList = articles.take(5).toList();
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: previewList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: StaggeredFadeSlide(
                      index: index,
                      child: ArticleCard(article: previewList[index]),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(child: Text('Error loading articles', style: AppTypography.caption)),
          ),
        ),
      ],
    );
  }
}
