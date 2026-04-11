import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/animated_button.dart';
import '../../../data/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onCommentTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onDeleteTap;

  const PostCard({
    super.key,
    required this.post,
    this.onCommentTap,
    this.onMoreTap,
    this.onLikeTap,
    this.onDeleteTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeScale;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  Color _getFlairColor(PostFlair flair) {
    switch (flair) {
      case PostFlair.anxiety:
        return AppColors.flairAnxiety;
      case PostFlair.gratitude:
        return AppColors.flairGratitude;
      case PostFlair.venting:
        return AppColors.flairVenting;
      case PostFlair.adviceNeeded:
        return AppColors.flairAdvice;
      case PostFlair.personalGrowth:
        return AppColors.flairGrowth;
      case PostFlair.other:
        return AppColors.flairOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final flairColor = _getFlairColor(post.flair);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row
          Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: post.isAnonymous
                    ? null
                    : () => context.push('/profile/${post.authorUid}'),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: post.isAnonymous || post.authorPhoto == null
                        ? LinearGradient(
                            colors: [
                              flairColor.withValues(alpha: 0.6),
                              flairColor.withValues(alpha: 0.3),
                            ],
                          )
                        : null,
                    image: !post.isAnonymous && post.authorPhoto != null
                        ? DecorationImage(
                            image: NetworkImage(post.authorPhoto!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: post.isAnonymous || post.authorPhoto == null
                      ? Center(
                          child: Text(
                            post.isAnonymous
                                ? 'A'
                                : (post.authorName.isNotEmpty
                                    ? post.authorName[0].toUpperCase()
                                    : '?'),
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: post.isAnonymous
                      ? null
                      : () => context.push('/profile/${post.authorUid}'),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.isAnonymous ? 'Anonymous' : post.authorName,
                        style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                      ),
                      Text(
                        AppDateUtils.timeAgo(post.createdAt),
                        style: AppTypography.caption
                            .copyWith(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              // Flair badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: flairColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post.flair.label,
                  style: AppTypography.caption.copyWith(
                    color: flairColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Delete button for author
              if (FirebaseAuth.instance.currentUser?.uid == post.authorUid)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Post'),
                        content: const Text('Are you sure you want to delete this post?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.onDeleteTap?.call();
                            },
                            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline_rounded,
                        color: AppColors.error, size: 20),
                  ),
                ),
              // More button
              GestureDetector(
                onTap: widget.onMoreTap,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_horiz_rounded,
                      color: AppColors.textMuted, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Post text
          Text(
            post.content,
            style: AppTypography.body.copyWith(
              height: 1.6,
              color: AppColors.textPrimary.withValues(alpha: 0.9),
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              // Like
              AnimatedButton(
                onTap: () {
                  _likeController.forward(from: 0);
                  widget.onLikeTap?.call();
                },
                child: Row(
                  children: [
                    ScaleTransition(
                      scale: _likeScale,
                      child: Icon(
                        post.isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 20,
                        color:
                            post.isLiked ? AppColors.error : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likeCount}',
                      style: AppTypography.caption.copyWith(
                        color: post.isLiked
                            ? AppColors.error
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Comments
              GestureDetector(
                onTap: widget.onCommentTap,
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentCount}',

                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Share
              const Icon(Icons.share_outlined,
                  size: 18, color: AppColors.textMuted),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
