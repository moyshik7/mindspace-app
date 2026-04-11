import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Terms of Service', style: AppTypography.headingM),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Terms of Service',
              style: AppTypography.headingL.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Please read these terms carefully before using our services. By using Mindspace, you agree to be bound by these terms.',
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              'Last Updated: January 2026',
              style: AppTypography.caption.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Acceptance of Terms',
              'By accessing and using the Mindspace website and services, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services. We reserve the right to modify these terms at any time, and your continued use of the site following any changes constitutes your acceptance of the new terms. We encourage you to review these terms periodically to stay informed of any updates.',
            ),
            _buildSection(
              'Use of Services',
              'Our services are intended to provide mental health information, resources, and support. You agree to use our services only for lawful purposes and in accordance with these terms. You may not use our services in any way that could damage, disable, overburden, or impair our servers or networks. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. Our services are not intended to replace professional medical advice, diagnosis, or treatment.',
            ),
            _buildSection(
              'Intellectual Property Rights',
              'All content on this website, including but not limited to text, graphics, logos, images, audio clips, digital downloads, and data compilations, is the property of Mindspace or its content suppliers and is protected by international copyright laws. The compilation of all content on this site is the exclusive property of Mindspace. You may not reproduce, distribute, modify, create derivative works of, publicly display, or exploit any of our content without prior written permission.',
            ),
            _buildSection(
              'Prohibited Activities',
              'You agree not to engage in any of the following prohibited activities: copying, distributing, or disclosing any part of the service in any medium; using any automated system to access the service; transmitting spam, chain letters, or other unsolicited communications; attempting to interfere with or compromise the system integrity or security; collecting or harvesting any personally identifiable information from the service; using the service for any commercial solicitation purposes; impersonating another person or otherwise misrepresenting your affiliation with a person or entity.',
            ),
            _buildSection(
              'Disclaimer of Warranties',
              'Our services are provided on an "as is" and "as available" basis without any warranties of any kind, either express or implied. We do not warrant that our services will be uninterrupted, timely, secure, or error-free. We do not warrant the accuracy or completeness of any information provided through our services. The mental health information provided is for educational purposes only and should not be considered as professional medical advice. Always consult with a qualified healthcare provider for medical concerns.',
            ),
            _buildSection(
              'Limitation of Liability',
              'In no event shall Mindspace, its directors, employees, partners, agents, suppliers, or affiliates be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the services; any conduct or content of any third party on the services; any content obtained from the services; and unauthorized access, use, or alteration of your transmissions or content.',
            ),
            _buildSection(
              'Governing Law',
              'These Terms of Service shall be governed by and construed in accordance with the laws of Bangladesh, without regard to its conflict of law provisions. You agree to submit to the personal and exclusive jurisdiction of the courts located in Bangladesh. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights. If any provision of these Terms is held to be invalid or unenforceable by a court, the remaining provisions will remain in effect.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary, height: 1.6),
          ),
        ],
      ),
    );
  }
}
