import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ConsultationHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onAvatarTap;
  const ConsultationHeader({super.key, required this.userName, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _WavyBottomClipper(),
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Evening!',
                      style: AppTypography.caption.copyWith(color: Colors.white70),
                    ),
                    Row(
                      children: [
                        Text(
                          userName,
                          style: AppTypography.headingM.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text('👋', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onAvatarTap,
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.medical_services_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Online Consultation',
                  style: AppTypography.headingM.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Large Card
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () => context.push('/home/counsellors'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Feeling low?\nLet\'s talk!',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'With real experts',
                              style: AppTypography.caption.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 16),
                            const Spacer(),
                            // Overlapping avatars
                            SizedBox(
                              height: 50,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.spa_rounded, color: Colors.black12, size: 50),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildAvatar("https://www.mindspacebd.com/team/shermin.webp"),
                                      Transform.translate(
                                        offset: const Offset(-10, 0),
                                        child: _buildAvatar("https://www.mindspacebd.com/team/rashida.webp"),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(-20, 0),
                                        child: _buildAvatar("https://www.mindspacebd.com/team/sm.webp"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right Cards
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // Talk with expert
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/home/counsellors'),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primaryLight,
                                    child: Icon(Icons.call, size: 14, color: AppColors.primaryDarkest),
                                  ),
                                  Text(
                                    'Talk with an\nexpert',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Book a Call', style: TextStyle(color: Colors.white, fontSize: 10)),
                                        Icon(Icons.chevron_right_rounded, color: Colors.white, size: 12),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Chat with expert
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/home/counsellors'),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.primaryLight,
                                    child: Icon(Icons.chat_bubble, size: 14, color: AppColors.primaryDarkest),
                                  ),
                                  Text(
                                    'Chat with an\nexpert',
                                    textAlign: TextAlign.center,
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Book a Chat', style: TextStyle(color: Colors.white, fontSize: 10)),
                                        Icon(Icons.chevron_right_rounded, color: Colors.white, size: 12),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}

class _WavyBottomClipper extends CustomClipper<Path> {
  const _WavyBottomClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width - (size.width / 4), size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
