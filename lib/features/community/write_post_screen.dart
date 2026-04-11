import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/gradient_button.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class WritePostScreen extends ConsumerStatefulWidget {
  const WritePostScreen({super.key});

  @override
  ConsumerState<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends ConsumerState<WritePostScreen> {
  final _textController = TextEditingController();
  PostFlair _selectedFlair = PostFlair.other;
  bool _isAnonymous = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_textController.text.trim().isEmpty || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(postRepositoryProvider).createPost(
        content: _textController.text.trim(),
        flair: _selectedFlair.label,
        isAnonymous: _isAnonymous,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post published successfully 🚀'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _textController.text.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Post',
          style: AppTypography.headingM.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text field
                  TextField(
                    controller: _textController,
                    maxLength: AppConstants.postMaxChars,
                    maxLines: null,
                    minLines: 6,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind?',
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                      filled: false,
                    ),
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Character counter
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$charCount/${AppConstants.postMaxChars}',
                      style: AppTypography.caption.copyWith(
                        color: charCount > AppConstants.postMaxChars - 50
                            ? AppColors.warning
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Flair selector
                  Text('Choose a flair', style: AppTypography.bodyMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PostFlair.values.map((flair) {
                      final isSelected = flair == _selectedFlair;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFlair = flair),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDeeper.withValues(alpha: 0.2)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceBorder,
                            ),
                          ),
                          child: Text(
                            flair.label,
                            style: AppTypography.caption.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Anonymous toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_off_rounded,
                            color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Post Anonymously',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: _isAnonymous,
                          onChanged: (v) => setState(() => _isAnonymous = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Publish button
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.surfaceBorder.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GradientButton(
                    text: 'Publish',
                    onTap: _publish,
                  ),
          ),
        ],
      ),
    );
  }
}

