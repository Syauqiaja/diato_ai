import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

/// Long-form HTML written in the console editor — a course body or a species
/// explanation — rendered with the app's headings and tappable pictures.
class RichHtmlContent extends StatelessWidget {
  final String html;

  const RichHtmlContent(this.html, {super.key});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      enableCaching: false,
      renderMode: RenderMode.column,
      buildAsync: true,
      customWidgetBuilder: (element) {
        switch (element.localName) {
          case "h1":
            return _heading(element.text, 22, FontWeight.w400, top: 8, bottom: 4);
          case "h2":
            return _heading(element.text, 18, FontWeight.w600, top: 20, bottom: 4);
          case "h3":
            return _heading(element.text, 16, FontWeight.w600, top: 8);
          case "h4":
            return _heading(element.text, 14, FontWeight.w600, top: 8);
          case "h5":
            return _heading(element.text, 12, FontWeight.w600, top: 8);
          case "img":
            final url = element.attributes['src'] ?? "";
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: () {
                  showImageViewerPager(
                    context,
                    SingleImageProvider(NetworkImage(url)),
                    immersive: false,
                    useSafeArea: true,
                    infinitelyScrollable: false,
                    backgroundColor: Colors.black54,
                  );
                },
                child: Image.network(url, fit: BoxFit.contain),
              ),
            );
          default:
            return null;
        }
      },
      textStyle: TextStyle(
        fontFamily: "georgia",
        height: 1.4,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _heading(
    String text,
    double fontSize,
    FontWeight weight, {
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom, left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          height: 1,
          fontFamily: "AndersonGrotesk",
          fontWeight: weight,
        ),
      ),
    );
  }
}
