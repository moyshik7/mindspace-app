import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user.name);
    _bioController = TextEditingController(text: user.bio);
    _descriptionController = TextEditingController(text: user.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(userProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            bio: _bioController.text.trim(),
            description: _descriptionController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Profile', style: AppTypography.headingM),
        actions: [
          _isSaving
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _saveProfile,
                  child: Text(
                    'Save',
                    style: AppTypography.button.copyWith(color: AppColors.primary),
                  ),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Name',
              controller: _nameController,
              hint: 'Your full name',
              maxLength: 50,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Bio',
              controller: _bioController,
              hint: 'Tell us a bit about yourself...',
              maxLength: 180,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Short Description',
              controller: _descriptionController,
              hint: 'A quick summary of who you are...',
              maxLength: 256,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required int maxLength,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.captionBold.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          style: AppTypography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),
            fillColor: AppColors.surface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            counterStyle: AppTypography.label,
          ),
        ),
      ],
    );
  }
}
