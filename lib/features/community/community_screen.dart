import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import '../../data/dummy_data.dart';
import '../../data/models/post_model.dart';
import 'widgets/post_card.dart';
import 'widgets/comment_sheet.dart';
import 'widgets/report_sheet.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late List<PostModel> _posts;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _posts = List<PostModel>.from(DummyData.posts);
  }

  void _toggleLike(int index) {
    setState(() {
      final post = _posts[index];
      _posts[index] = PostModel(
        id: post.id,
        username: post.username,
        flair: post.flair,
        text: post.text,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        comments: post.comments,
        createdAt: post.createdAt,
        isLiked: !post.isLiked,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Top bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Community', style: AppTypography.headingL),
                        const SizedBox(width: 6),
                        const Text('🌱', style: TextStyle(fontSize: 22)),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() => _showSearch = !_showSearch);
                          },
                          icon: Icon(
                            _showSearch
                                ? Icons.close_rounded
                                : Icons.search_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Animated search bar
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search posts...',
                            prefixIcon: const Icon(Icons.search_rounded,
                                size: 20),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            filled: true,
                            fillColor: AppColors.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.surfaceBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.surfaceBorder),
                            ),
                          ),
                          style: AppTypography.body,
                        ),
                      ),
                      crossFadeState: _showSearch
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ),

            // Post feed
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return StaggeredFadeSlide(
                      index: index,
                      child: PostCard(
                        post: _posts[index],
                        onLikeTap: () => _toggleLike(index),
                        onCommentTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const CommentSheet(),
                          );
                        },
                        onMoreTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ReportSheet(),
                          );
                        },
                      ),
                    );
                  },
                  childCount: _posts.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () => context.push('/community/write-post'),
          backgroundColor: AppColors.primaryDeeper,
          child: const Icon(Icons.edit_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
