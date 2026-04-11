import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/counsellor_model.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

class CounsellorDetailScreen extends StatelessWidget {
  final CounsellorModel counsellor;
  
  const CounsellorDetailScreen({super.key, required this.counsellor});

  void _bookNow() async {
    final message = "[Booking] Counselor: ${counsellor.name}";
    final url = Uri.parse('https://wa.me/+8801805527311?text=${Uri.encodeComponent(message)}');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
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
                    const Expanded(
                      child: Text(
                        'Expert Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for centering
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile Image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF08B),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        counsellor.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.black12, size: 80),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF07CDAB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                counsellor.name,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                counsellor.title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _StatPill(icon: Icons.history_edu_rounded, text: counsellor.experience, iconColor: const Color(0xFF07CDAB)),
                  const SizedBox(width: 12),
                  const _StatPill(icon: Icons.chat_bubble_outline, text: '500+ sessions', iconColor: Color(0xFF07CDAB)),
                  const SizedBox(width: 12),
                  _StatPill(icon: Icons.payments_outlined, text: '৳${counsellor.price}', iconColor: const Color(0xFF07CDAB)),
                ],
              ),

              const SizedBox(height: 16),
              const Text(
                'আপনার পাশে আছি - Your story is safe here.',
                style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontSize: 12),
              ),

              const SizedBox(height: 24),
              // Book Now Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _bookNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07CDAB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              
              // Know Your Expert Section
              const Text(
                'Know Your Expert',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verified by Mindspace • Trusted by 500+ clients',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),

              const SizedBox(height: 20),

              // Info Box Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Fake Tabs
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C34),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF383842),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(child: Text('About', style: TextStyle(color: Colors.white, fontSize: 12))),
                            )),
                            const Expanded(child: Center(child: Text('Education', style: TextStyle(color: Colors.white54, fontSize: 12)))),
                            const Expanded(flex: 2, child: Center(child: Text('Therapy Approach', style: TextStyle(color: Colors.white54, fontSize: 12)))),
                          ],
                        ),
                      ),
                    ),
                    
                    // About Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_border, color: Colors.white54, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'About ${counsellor.name.split(' ').first}',
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            counsellor.shortBio,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Specialties',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: counsellor.expertise.map((exp) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C2C34),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(exp, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _StatPill({required this.icon, required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
