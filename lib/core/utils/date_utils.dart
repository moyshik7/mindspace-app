import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dateTime);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isConsecutiveDay(DateTime previous, DateTime current) {
    final previousDate = DateTime(previous.year, previous.month, previous.day);
    final currentDate = DateTime(current.year, current.month, current.day);
    return currentDate.difference(previousDate).inDays == 1;
  }
}
