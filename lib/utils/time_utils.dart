import 'package:intl/intl.dart';

class TimeUtils {
  /// Format DateTime to 12-hour format with AM/PM
  static String format12Hour(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format time string (HH:mm) to 12-hour format
  static String formatTimeString12Hour(String timeString) {
    try {
      // Parse the time string (assuming HH:mm format)
      final parts = timeString.split(':');
      if (parts.length != 2) return timeString;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      // Create a DateTime object for today with the given time
      final dateTime = DateTime(2023, 1, 1, hour, minute);
      
      return format12Hour(dateTime);
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }

  /// Convert 12-hour format back to 24-hour format for storage
  static String format24Hour(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Parse 12-hour format time and return 24-hour format
  static String parse12HourTo24Hour(String time12Hour) {
    try {
      final dateTime = DateFormat('h:mm a').parse(time12Hour);
      return format24Hour(dateTime);
    } catch (e) {
      return time12Hour; // Return original if parsing fails
    }
  }

  /// Format DateTime for display in lists (includes date and 12-hour time)
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • h:mm a').format(dateTime);
  }

  /// Format just the date
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  /// Get current time in 12-hour format
  static String getCurrentTime12Hour() {
    return format12Hour(DateTime.now());
  }

  /// Check if a time string is in 12-hour format
  static bool is12HourFormat(String timeString) {
    return timeString.toLowerCase().contains('am') || timeString.toLowerCase().contains('pm');
  }

  /// Get list of common time slots in 12-hour format
  static List<String> getCommonTimeSlots() {
    return [
      '6:00 AM',  // Morning
      '8:00 AM',  // Breakfast
      '12:00 PM', // Lunch
      '6:00 PM',  // Dinner
      '9:00 PM',  // Evening
      '10:00 PM', // Night
    ];
  }

  /// Convert a list of 24-hour times to 12-hour format
  static List<String> convertTimesTo12Hour(List<String> times24Hour) {
    return times24Hour.map((time) => formatTimeString12Hour(time)).toList();
  }

  /// Convert a list of 12-hour times to 24-hour format
  static List<String> convertTimesTo24Hour(List<String> times12Hour) {
    return times12Hour.map((time) => parse12HourTo24Hour(time)).toList();
  }
}