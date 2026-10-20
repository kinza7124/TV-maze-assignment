import 'package:flutter_application_1/core/utils/text_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextUtils.stripHtml', () {
    test('removes HTML tags', () {
      expect(
        TextUtils.stripHtml('<p><b>Dark</b> is a <i>German</i> show.</p>'),
        'Dark is a German show.',
      );
    });

    test('converts HTML entities to normal characters', () {
      expect(
        TextUtils.stripHtml('Tom &amp; Jerry&nbsp;say &quot;hi&quot; &#39;x&#39;'),
        'Tom & Jerry say "hi" \'x\'',
      );
    });

    test('returns an empty string for null or empty text', () {
      expect(TextUtils.stripHtml(null), '');
      expect(TextUtils.stripHtml(''), '');
    });
  });

  group('TextUtils.formatDate', () {
    test('formats "2008-01-20" as "Jan 20, 2008"', () {
      expect(TextUtils.formatDate('2008-01-20'), 'Jan 20, 2008');
    });

    test('formats the last month correctly', () {
      expect(TextUtils.formatDate('2013-12-01'), 'Dec 1, 2013');
    });

    test('returns "Unknown date" for null or empty dates', () {
      expect(TextUtils.formatDate(null), 'Unknown date');
      expect(TextUtils.formatDate(''), 'Unknown date');
    });

    test('returns the text unchanged if it is not a date', () {
      expect(TextUtils.formatDate('soon'), 'soon');
    });
  });
}
