import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/counsellor_model.dart';
import 'providers/counsellors_provider.dart';

class CounsellorsScreen extends ConsumerWidget {
  const CounsellorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counsellorsAsync = ref.watch(counsellorsProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background matching the image
      appBar: AppBar(
        title: const Text('Experts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: counsellorsAsync.when(
        data: (counsellors) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07CDAB).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF07CDAB).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFF07CDAB)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your first counseling session. Professional mental health support starting from 800 Taka',
                          style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.76,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final counsellor = counsellors[index];
                    return _GridCounsellorCard(counsellor: counsellor);
                  },
                  childCount: counsellors.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF07CDAB))),
        error: (err, stack) => const Center(child: Text('Error loading experts', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

class _GridCounsellorCard extends StatelessWidget {
  final CounsellorModel counsellor;

  const _GridCounsellorCard({required this.counsellor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/home/counsellors/${counsellor.id}', extra: counsellor),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C1D), // Dark brownish-grey card equivalent
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 16),
        child: Column(
          children: [
            // Image with Yellow circle background
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF08B), // Pale Yellow
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      counsellor.image,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.black12, size: 60),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF32282C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(counsellor.experience, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.history_edu_rounded, color: Color(0xFF07CDAB), size: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              counsellor.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              counsellor.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            const SizedBox(height: 2),
            Text(
              '৳${counsellor.price}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF07CDAB), fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF07CDAB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
