import 'package:flutter/material.dart';

/// [text] with every case-insensitive occurrence of [query] picked out, so a
/// search result shows where it matched.
class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;

  const HighlightedText(
    this.text, {
    super.key,
    required this.query,
    this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = (style ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w700,
      backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
    );

    return Text.rich(
      TextSpan(style: style, children: highlightSpans(text, query, highlight)),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

/// Splits [text] into plain and highlighted runs around [query].
List<TextSpan> highlightSpans(String text, String query, TextStyle highlight) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return [TextSpan(text: text)];

  final haystack = text.toLowerCase();
  final spans = <TextSpan>[];
  var start = 0;

  while (true) {
    final at = haystack.indexOf(needle, start);
    if (at < 0) break;
    if (at > start) spans.add(TextSpan(text: text.substring(start, at)));
    spans.add(TextSpan(text: text.substring(at, at + needle.length), style: highlight));
    start = at + needle.length;
  }
  if (start < text.length) spans.add(TextSpan(text: text.substring(start)));

  return spans;
}
