import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import 'providers/community_provider.dart';
import 'widgets/post_card.dart';
import 'widgets/comment_sheet.dart';
import 'widgets/report_sheet.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  bool _showSearch = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(communityNotifierProvider.notifier).fetchPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.read(communityNotifierProvider.notifier).fetchPosts(refresh: true),
          child: CustomScrollView(
            controller: _scrollController,
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

              if (communityState.posts.isEmpty && communityState.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (communityState.posts.isEmpty && communityState.error != null)
                SliverFillRemaining(
                  child: Center(child: Text(communityState.error!)),
                )
              else if (communityState.posts.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('No posts yet.')),
                )
              else
                // Post feed
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return StaggeredFadeSlide(
                          index: index,
                          child: PostCard(
                            post: communityState.posts[index],
                            onLikeTap: () {
                              ref.read(communityNotifierProvider.notifier).toggleLike(communityState.posts[index].id);
                            },
                            onDeleteTap: () {
                              ref.read(communityNotifierProvider.notifier).deletePost(communityState.posts[index].id);
                            },
                            onCommentTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => CommentSheet(postId: communityState.posts[index].id),
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
                      childCount: communityState.posts.length,
                    ),
                  ),
                ),

              if (communityState.isLoading && communityState.posts.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100, top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
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
