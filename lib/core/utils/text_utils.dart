/// Helper functions for text formatting.
class TextUtils {
  /// TVMaze summaries contain HTML like "<p><b>Dark</b> is...</p>".
  /// This removes the tags so we can show plain text.
  static String stripHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  /// Converts "2008-01-20" into "Jan 20, 2008".
  static String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Unknown date';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }
}
