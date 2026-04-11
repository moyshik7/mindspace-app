import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../providers/comments_provider.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final TextEditingController _controller = TextEditingController();

  void _sendComment() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(commentsNotifierProvider(widget.postId).notifier).addComment(text, false);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(commentsNotifierProvider(widget.postId));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text('Comments', style: AppTypography.headingM),
                    const SizedBox(width: 8),
                    Text(
                      '(${commentsState.comments.length})',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Comments list
              Expanded(
                child: commentsState.isLoading && commentsState.comments.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: commentsState.comments.length,
                        itemBuilder: (context, index) {
                          final comment = commentsState.comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      comment.authorName[0].toUpperCase(),
                                      style: AppTypography.captionBold.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comment.authorName,
                                            style: AppTypography.captionBold.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            AppDateUtils.timeAgo(comment.createdAt),
                                            style: AppTypography.caption.copyWith(
                                              color: AppColors.textMuted,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment.content,
                                        style: AppTypography.body.copyWith(
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              ref.read(commentsNotifierProvider(widget.postId).notifier).toggleLike(comment.id);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  comment.isLiked
                                                      ? Icons.favorite_rounded
                                                      : Icons.favorite_border_rounded,
                                                  size: 14,
                                                  color: comment.isLiked
                                                      ? AppColors.error
                                                      : AppColors.textMuted,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  '${comment.likeCount}',
                                                  style: AppTypography.caption.copyWith(fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.more_horiz_rounded,
                                              size: 16,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Input bar
              Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  10 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.surfaceBorder.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(bottom: 10),
                              hintStyle: AppTypography.body.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            style: AppTypography.body,
                            onSubmitted: (_) => _sendComment(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _sendComment,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
