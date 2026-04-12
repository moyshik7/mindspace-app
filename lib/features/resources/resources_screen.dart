import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/staggered_fade_slide.dart';
import '../../data/dummy_data.dart';
import '../home/widgets/quick_guides_section.dart';
import '../home/widgets/courses_section.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Text('Resources', style: AppTypography.headingL),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Quick Guides
                  StaggeredFadeSlide(
                    index: 0,
                    child: QuickGuidesSection(guides: DummyData.guides),
                  ),
                  const SizedBox(height: 24),

                  // Courses
                  StaggeredFadeSlide(
                    index: 1,
                    child: CoursesSection(courses: DummyData.courses),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
